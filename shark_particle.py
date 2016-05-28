# ------------------------------------------------------------------------
# coding=utf-8
# ------------------------------------------------------------------------
# Shark simulator and visualization given attraction and repulsion factors.
# Adapted from Chris Clark's fishSim_7 Matlab code.
# ------------------------------------------------------------------------

from __future__ import absolute_import

import random
import math
import scipy.stats
import numpy as np
import time
import matplotlib.pyplot as plt
from shapely.geometry import LineString, Point

from draw import Maze

# 0 - empty square
# 1 - occupied square

maze_data = ((1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
             (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))

HEIGHT = 30
WIDTH = 30
HALF_HEIGHT = HEIGHT/2
HALF_WIDTH = WIDTH/2
TIME_STEPS = 1000
PARTICLE_COUNT = 1  # Total number of particles
# SHARK_COUNT = 112
GAUSS_VARIANCE = 25

FISH_INTERACTION_RADIUS = 1.5
SHOW_VISUALIZATION = False
SIGMA_MEAN = 0.1
LINE_START = (-9, 8)
LINE_END = (8, 5)

# Fish simulation constants

# Around 20 Degrees
SIGMA_RAND = 0.35
K_CON = 0.05
# TODO: ask Chris about constants
K_REP = 1000
# K_ATT = 0.0000002
# TODO: for now use 1
K_ATT = 100
K_RAND = 0.1

# Yaw Control
MAX_CONTROL = 20 * math.pi / 180


# ------------------------------------------------------------------------
# Some utility functions

def add_noise(level, *coords):
    return [x + random.uniform(-level, level) for x in coords]


def add_little_noise(*coords):
    return add_noise(0.02, *coords)


def add_some_noise(*coords):
    return add_noise(0.1, *coords)


def gauss(error):
    # TODO: variance is derived experimentally
    return scipy.stats.norm.pdf(error, 0, GAUSS_VARIANCE)

def distance_from_line(shark, line):
    p = Point(shark.x, shark.y)
    return p.distance(line)


# ------------------------------------------------------------------------
def compute_particle_means(particles, world):
    """
    Compute the mean for all particles that have a reasonably good weight.
    This is not part of the particle filter algorithm but rather an
    addition to show the "best belief" for current position.
    """
    m_x1, m_y1, m_x2, m_y2, m_count = 0, 0, 0, 0, 0
    for p in particles:
        m_count += p.w
        m_x1 += p.x1 * p.w
        m_y1 += p.y1 * p.w
        m_x2 += p.x2 * p.w
        m_y2 += p.y2 * p.w

    if m_count == 0:
        return -1, -1, False

    m_x1 /= m_count
    m_y1 /= m_count
    m_x2 /= m_count
    m_y2 /= m_count

    # Now compute how good that mean is -- check how many particles
    # actually are in the immediate vicinity
    m_count = 0
    for p in particles:
        if world.distance(p.x1, p.y1, m_x1, m_y1) < 1:
            m_count += 1

    m1 = (m_x1, m_y1)
    m2 = (m_x2, m_y2)

    return m1, m2, m_count > PARTICLE_COUNT * 0.95


# ------------------------------------------------------------------------
class Particle(object):
    def __init__(self, x1, y1, x2, y2, heading=None, w=1, noisy=False):
        if heading is None:
            heading = random.uniform(0,math.pi)
        if noisy:
            x1, y1, heading = add_some_noise(x1, y1, heading)

        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.h = heading
        self.w = w

    def __repr__(self):
        return "(%f, %f, w=%f)" % (self.x, self.y, self.w)

    @property
    def xy(self):
        return self.x, self.y

    @property
    def xy1(self):
        return self.x1, self.y1

    @property
    def xy2(self):
        return self.x2, self.y2

    def xyh(self):
        return self.x, self.y, self.h

    @classmethod
    def create_random(cls, count, maze):

        return [cls(random.uniform(-HALF_WIDTH, HALF_WIDTH), random.uniform(-HALF_HEIGHT, HALF_HEIGHT),
                    random.uniform(-HALF_WIDTH, HALF_WIDTH), random.uniform(-HALF_HEIGHT, HALF_HEIGHT)) for _ in range(0, count)]

    def read_distance_sensor(self, robot):
        """
        Returns distance between self and robot.
        """
        self_x, self_y = self.xy
        robot_x, robot_y = robot.xy
        return math.sqrt((self_x - robot_x)**2 + (self_y - robot_y)**2)

    def read_angle_sensor(self,robot):
        self_x, self_y = self.xy
        robot_x, robot_y = robot.xy
        return math.degrees(math.atan2(abs(self_y - robot_y), abs(self_x - robot_x)))

    def distance_to_wall(self,maze):

        return maze.distance_to_wall(*self.xyh)

    def advance_by(self, speed, checker=None, noisy=False):
        h = self.h
        if noisy:
            speed, h = add_little_noise(speed, h)
            h += random.uniform(-0.25, 0.25) # needs more noise to disperse better
        r = h
        # Calculate cartesian distance
        dx = math.cos(r) * speed
        dy = math.sin(r) * speed
        # Checks if, after advancing, particle is still in the box
        if checker is None or checker(self, dx, dy):
            self.move_by(dx, dy)
            return True
        return False

    def move_by(self, x, y):
        self.x += x
        self.y += y

class Robot(Particle):
    speed = 0.01

    def __init__(self, x, y, heading=None, w=1, noisy=False):
        if heading is None:
            heading = random.uniform(0, math.pi)
        if noisy:
            x, y, heading = add_some_noise(x, y, heading)

        self.x = 8
        self.y = 8
        self.h = heading
        self.w = w
        self.step_count = 0
        # self.color = random.random(), random.random(), random.random()


    def chose_random_direction(self):
        heading = random.uniform(0, math.pi)
        self.h = heading

    def move(self, maze):
        """
        Move the robot. Note that the movement is stochastic too.
        """
        while True:
            self.step_count += 1
            if self.advance_by(self.speed, noisy=True,
                checker=lambda r, dx, dy: maze.is_free(r.x+dx, r.y+dy)):
                break
            # Bumped into something or too long in same direction,
            # chose random new direction
            self.chose_random_direction()

class Shark(Particle):
    speed = 0.05

    def __init__(self, x, y, tracked=False, heading=None, w=1, noisy=False):
        if heading is None:
            heading = random.uniform(- math.pi, math.pi)
        if noisy:
            x, y, heading = add_some_noise(x, y, heading)

        self.x = 0
        self.y = 0
        self.h = heading
        self.tracked = tracked
        self.w = w
        self.step_count = 0
        self.color = random.random(), random.random(), random.random()
        self.in_zone = False
        self.last_alpha = 0

    def __repr__(self):
        return "(%f, %f, w=%f, tracked=%r)" % (self.x, self.y, self.w, self.tracked)

    @classmethod
    def create_random(cls, count, maze, track_count):
        return [cls(*maze.random_free_place(), tracked=True if i < track_count else False) for i in
                range(0, count)]

    def chose_random_direction(self):
        heading = random.uniform(0, math.pi)
        self.h = heading

    def distance(self, shark):
        return math.sqrt((self.x - shark.x) ** 2 + (self.y - shark.y) ** 2)

    def read_distance_sensor(self, robot):
        """
        Poor robot, it's sensors are noisy and pretty strange,
        it can only know laser sensor wall distance(!)
        and is not very accurate at that too!
        """
        return add_little_noise(super(Shark, self).read_distance_sensor(robot))[0]

    def move(self, maze):
        """
        Move the robot. Note that the movement is stochastic too.
        """
        while True:
            self.step_count += 1
            if self.advance_by(self.speed, noisy=True,
                               checker=lambda r, dx, dy: maze.is_free(r.x + dx, r.y + dy)):
                break
            # Bumped into something or too long in same direction,
            # chose random new direction
            self.chose_random_direction()

    def angle_diff(self, desired_theta):
        """
        :return: Difference between heading and desired_theta within -pi and pi.
        """
        h = self.h
        a = desired_theta - h
        while a > math.pi:
            a -= 2 * math.pi
        while a < -math.pi:
            a += 2 * math.pi
        return a

    def find_repulsion(self, sharks):
        """
        :param sharks: list of sharks
        :return: Repulsion contribution (x and y) to movement
        """
        x_rep = 0
        y_rep = 0
        for shark in sharks:
            dist = self.distance(shark)
            if dist < FISH_INTERACTION_RADIUS and dist != 0:
                mag = (1 / dist - 1 / FISH_INTERACTION_RADIUS) ** 2
                x_rep += mag * (self.x - shark.x)
                y_rep += mag * (self.y - shark.y)
        return x_rep, y_rep

    def find_attraction(self, attractors):
        """
        :param attractors: List of attraction points
        :return: Attractor contribution (x and y) to shark's movement
        """
        x_att = 0
        y_att = 0
        for attractor in attractors:
            mag = (attractor[0] - self.x) ** 2 + (attractor[1] - self.y) ** 2
            x_att += mag * (attractor[0] - self.x)
            y_att += mag * (attractor[1] - self.y)
        return x_att, y_att

    def find_attraction_to_line(self, line):
        """ Finds attractor line contribution to shark's movement
        """
        # Find closest point on attraction line
        p = Point(self.x, self.y)
        projection = line.project(p)
        np = line.interpolate(projection)
        attractors = [(np.x, np.y)]

        # Find Attraction based on Closest Point
        x_att, y_att = self.find_attraction(attractors)

        return x_att, y_att


    def advance(self, sharks, speed, sigma_rand, k_att, k_rep, line, noisy=False, checker=None):
        """
        :param
                k_att: Attraction Gain
                k_rep: Repulsive Gain
        :return: Advance shark by one step.
        """
        # Get attributes
        # x_att, y_att = self.find_attraction(ATTRACTORS)
        x_att, y_att = self.find_attraction_to_line(line)
        x_rep, y_rep = self.find_repulsion(sharks)

        # Sum all potentials
        x_tot = k_att * x_att + k_rep * x_rep
        y_tot = k_att * y_att + k_rep * y_rep
        desired_theta = math.atan2(y_tot, x_tot)

        # Set yaw control
        control_theta = K_CON * (self.angle_diff(desired_theta)) + sigma_rand * np.random.randn(1)[0]
        control_theta = min(max(control_theta, - MAX_CONTROL), MAX_CONTROL)
        self.h += control_theta

        # Calculate cartesian distance
        dx = math.cos(self.h) * speed
        dy = math.sin(self.h) * speed

        # Checks if, after advancing, shark is still in the box
        if checker is None or checker(self, dx, dy):
            self.move_by(dx, dy)
            return True
        return False

def move(world, robots, sharks, att_line, particles_list, sigma_rand, k_att, k_rep):
    # ---------- Move things ----------
    for robot in robots:
        robot.move(world)

    d_h = []
    for shark in sharks:
        old_heading = shark.h
        shark.advance(sharks, shark.speed, sigma_rand, k_att, k_rep, att_line)
        d_h.append(shark.h - old_heading)

    # Move particles according to my belief of movement (this may
    # be different than the real movement, but it's all I got)
    for i, particles in enumerate(particles_list):

        for p in particles:
            p.x1 += np.random.normal(0, SIGMA_MEAN)
            p.y1 += np.random.normal(0, SIGMA_MEAN)

            p.x2 += np.random.normal(0, SIGMA_MEAN)
            p.y2 += np.random.normal(0, SIGMA_MEAN)

def show(world, robots, sharks, particles_list, means_list, est_line_start, est_line_end, att_line, attraction_point=(0, 0)):
    """
    :param has_particle:
    :return: Shows robots, sharks, particles and means.
    """
    for particles in particles_list:
        world.show_particles(particles)
    world.show_attraction_point(attraction_point)

    for mean in means_list:
        world.show_mean(mean)

    for robot in robots:
        world.show_robot(robot)

    world.show_est_line(est_line_start, est_line_end)
    world.show_att_line(att_line.coords[0], att_line.coords[1])

    world.show_sharks(sharks)



# ------------------------------------------------------------------------
def main():
    world = Maze(maze_data, HALF_WIDTH, HALF_HEIGHT)
    world.draw()


    for shark_count in range(151)[10::10]:
    # Initialize Items
        sharks = Shark.create_random(shark_count, world, 0)
        robert = Robot(world, 0,0)
        robots = [robert]
        no_particles = []

        # Write to File
        my_file = open("%sSharksDistFromLine.txt" %(shark_count), "w")

        # Header describing model
        my_file.write("Line Start: %s, Line End: %s" %(LINE_START, LINE_END))
        my_file.write("\n")
        my_file.write("NumSharks: %s, K_att: %s, K_rep: %s, Sigma_Rand: %s, Speed/ts: %s" %(shark_count, K_ATT, K_REP, SIGMA_RAND, Shark.speed))
        my_file.write("\n")


        att_line = LineString([LINE_START, LINE_END])

        # Let sharks move towards attraction line first
        for time_step in range(300):
            move(world, robots, sharks, att_line, no_particles, SIGMA_RAND, K_ATT, K_REP)

        # while True:
        for _ in range(3):
            for time_step in range(TIME_STEPS):
                #
                # ---------- Show current state ----------
                if SHOW_VISUALIZATION:
                    world.show_sharks(sharks)
                    world.show_robot(robert)
                    world.show_att_line(LINE_START, LINE_END)

                move(world, robots, sharks, att_line, no_particles, SIGMA_RAND, K_ATT, K_REP)
                for shark in sharks:
                    # my_file.write("%s, %s," % (shark.x, shark.y))
                    my_file.write("%s, " %(distance_from_line(shark, att_line)))
                my_file.write("\n")

                print time_step

        my_file.close()



if __name__ == "__main__":
    main()