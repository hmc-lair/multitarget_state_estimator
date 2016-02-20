# ------------------------------------------------------------------------
# coding=utf-8
# ------------------------------------------------------------------------
#
#  Created by Martin J. Laubach on 2011-11-15
#  Modified by Cherie Ho on 2015-11-11
#
# ------------------------------------------------------------------------

from __future__ import absolute_import

import random
import math
import bisect
import scipy.stats
import numpy as np
import time

from draw import Maze

# 0 - empty square
# 1 - occupied square
# 2 - occupied square with a beacon at each corner, detectable by the robot

# Smaller maze

maze_data = ( ( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
              ( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))


PARTICLE_COUNT = 1000    # Total number of particles
SHARK_COUNT = 1

ATTRACTORS = [(8,8)]
FISH_INTERACTION_RADIUS = 0

# Simulation Constants

SIGMA_RAND = 0.1
K_CON = 0.1
K_REP = 500000
K_ATT = 0.0000002
K_RAND = 0.1

# Yaw Control
MAX_CONTROL = 20 * math.pi/180

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
    return scipy.stats.norm.pdf(error, 0, 0.5)

# ------------------------------------------------------------------------
def compute_mean_point(particles):
    """
    Compute the mean for all particles that have a reasonably good weight.
    This is not part of the particle filter algorithm but rather an
    addition to show the "best belief" for current position.
    """

    m_x, m_y, m_count = 0, 0, 0
    for p in particles:
        m_count += p.w
        m_x += p.x * p.w
        m_y += p.y * p.w

    if m_count == 0:
        return -1, -1, False

    m_x /= m_count
    m_y /= m_count

    # Now compute how good that mean is -- check how many particles
    # actually are in the immediate vicinity
    m_count = 0
    for p in particles:
        if world.distance(p.x, p.y, m_x, m_y) < 1:
            m_count += 1

    return m_x, m_y, m_count > PARTICLE_COUNT * 0.95

# ------------------------------------------------------------------------
class WeightedDistribution(object):
    def __init__(self, state):
        accum = 0.0
        self.state = [p for p in state if p.w > 0]
        self.distribution = []
        for x in self.state:
            accum += x.w
            self.distribution.append(accum)

    def pick(self):
        try:
            # TODO: ask Chris about how to pick
            # Pick randomly from self.distribution
            return self.state[bisect.bisect_left(self.distribution, random.uniform(0, 1))]
        except IndexError:
            # Happens when all particles are improbable w=0
            return None

# ------------------------------------------------------------------------
class Particle(object):
    def __init__(self, x, y, heading=None, w=1, noisy=False):
        if heading is None:
            heading = random.uniform(0, 360)
        if noisy:
            x, y, heading = add_some_noise(x, y, heading)

        self.x = x
        self.y = y
        self.h = heading
        self.w = w

    def __repr__(self):
        return "(%f, %f, w=%f)" % (self.x, self.y, self.w)

    @property
    def xy(self):
        return self.x, self.y


    def xyh(self):
        return self.x, self.y, self.h

    @classmethod
    def create_random(cls, count, maze):
        return [cls(*maze.random_free_place()) for _ in range(0, count)]
        # return [cls(12,8) for _ in range(0, count)]
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
            h += random.uniform(-3, 3) # needs more noise to disperse better
        r = math.radians(h)
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

# ------------------------------------------------------------------------
class Robot(Particle):
    speed = 0.2

    def __init__(self, maze):
        super(Robot, self).__init__(8, 8, heading=90)
        self.chose_random_direction()
        self.step_count = 0

    def chose_random_direction(self):
        heading = random.uniform(0, 360)
        self.h = heading

    # def read_sensor(self, robot):
    #     """
    #     Poor robot, it's sensors are noisy and pretty strange,
    #     it can only know laser sensor wall distance(!)
    #     and is not very accurate at that too!
    #     """
    #     return add_little_noise(super(Robot, self).read_distance_sensor(robot))

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



# ------------------------------------------------------------------------

class Shark(Particle):
    speed = 0.2

    def __init__(self, x, y, r,heading=None, w=1, noisy=False):
        if heading is None:
            heading = random.uniform(0, 360)
        if noisy:
            x, y, heading = add_some_noise(x, y, heading)

        self.x = x
        self.y = y
        self.h = heading
        self.w = w
        self.step_count = 0
        self.color = random.random(), random.random(), random.random()
        self.r = r

    def distance(self, shark):
        return math.sqrt((self.x - shark.x)^2 + (self.y - shark.y)^2)

    def chose_random_direction(self):
        heading = random.uniform(0, 360)
        self.h = heading

    def find_repulsion(self, sharks):
        """
        :param sharks: list of sharks
        :return: Repulsion contribution (x and y) to movement
        """
        x_rep = 0
        y_rep = 0
        for shark in sharks:
            dist = self.distance(shark)
            if self is not shark and dist< FISH_INTERACTION_RADIUS:
                mag = (1/dist - 1/FISH_INTERACTION_RADIUS)**2
                x_rep += mag * (self.x - shark.x)
                y_rep += mag * (self.y - shark.y)
        return x_rep, y_rep

    def find_attraction(self, attractors):
        """
        :param attractors: List of attraction points
        :return: Attractor contribution to shark's movement
        """
        x_att = 0
        y_att = 0
        for attractor in attractors:
            mag = (attractor[0]-self.x)**2 + (attractor[1]-self.y)**2
            print "mag",mag
            x_att += mag * (attractor[0] - self.x)
            y_att += mag * (attractor[1] - self.y)
        return x_att, y_att

    def read_distance_sensor(self, robot):
        """
        Poor robot, it's sensors are noisy and pretty strange,
        it can only know laser sensor wall distance(!)
        and is not very accurate at that too!
        """
        return add_little_noise(super(Shark, self).read_distance_sensor(robot))

    def read_distance_sensor(self, robot):
        """
        Poor robot, it's sensors are noisy and pretty strange,
        it can only know laser sensor wall distance(!)
        and is not very accurate at that too!
        """
        return add_little_noise(super(Shark, self).read_distance_sensor(robot))

    def move(self, maze):
        """
        Move the shark. Note that the movement is stochastic too.
        """
        while True:
            self.step_count += 1
            # TODO : change noisy to True
            if self.advance_by(self.speed, noisy=False,
                checker=lambda r, dx, dy: maze.is_free(r.x+dx, r.y+dy)):
                break
            # Bumped into something or too long in same direction,
            # chose random new direction
            self.chose_random_direction()

    def angle_diff(self, desired_theta):
        h = self.h
        a = desired_theta - h
        if a > math.pi:
            a -= 2 * math.pi
        if a < -math.pi:
            a += 2 * math.pi
        return a

    def advance(self, speed, checker=None, noisy=False):
        # Get attributes
        x_att, y_att = self.find_attraction(ATTRACTORS)
        x_rep, y_rep = 0, 0 # TODO: check repulsion

        # Sum all potentials
        x_tot = K_ATT * x_att + K_REP * x_rep
        y_tot = K_ATT * y_att + K_REP * y_rep
        desired_theta = math.degrees(math.atan2(y_tot, x_tot))
        print "x_tot", x_tot
        print "y_tot", y_tot


        # if noisy:
        #     speed, h = add_little_noise(speed, h)
        #     h += random.uniform(-3, 3) # needs more noise to disperse better

        # Set yaw control
        control_theta = K_CON * (self.angle_diff(desired_theta)) + SIGMA_RAND * np.random.randn(1)
        # control_theta = min(max(control_theta, - MAX_CONTROL), MAX_CONTROL)
        print "desired_theta", desired_theta
        print "control_theta", control_theta
        # print type(control_theta)
        self.h += control_theta
        print "self.h", self.h
        r = math.radians(self.h)
        print "r", r
        # Calculate cartesian distance
        dx = math.cos(r) * speed
        print "dx", dx
        dy = math.sin(r) * speed
        print "dy", dy
        # Checks if, after advancing, particle is still in the box
        if checker is None or checker(self, dx, dy):
            self.move_by(dx, dy)
            return True
        return False

# ------------------------------------------------------------------------

world = Maze(maze_data)
world.draw()

# Initialize Sharks
sharks = Shark.create_random(SHARK_COUNT, world)
robert = Robot(world)

while True:


    # ---------- Show current state ----------
    world.show_sharks(sharks)
    world.show_robot(robert)


    # # ---------- Move things ----------

    # Move sharks with shark's speed
    for s in sharks:
        s.advance(s.speed)
    time.sleep(0.5)
