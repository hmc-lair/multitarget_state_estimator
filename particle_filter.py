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
import matplotlib.pyplot as plt
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


PARTICLE_COUNT = 500    # Total number of particles
TIME_STEPS = 100 # Number of steps before simulation ends

SHOW_VISUALIZATION = True # Whether to have visualization

ROBOT_HAS_COMPASS = False
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
def compute_mean_point(particles, world):
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
            heading = random.uniform(0,math.pi)
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

    # def read_wall_sensor(self, maze):
    #     """
    #     Find distance to wall with the laser range sensor at a specific orientation.
    #     """
    #     return maze.distance_to_wall(*self.xyh)

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

# ------------------------------------------------------------------------
class Robot(Particle):
    speed = 0.2

    def __init__(self, x, y, heading=None, w=1, noisy=False):
        if heading is None:
            heading = random.uniform(0, math.pi)
        if noisy:
            x, y, heading = add_some_noise(x, y, heading)

        self.x = x
        self.y = y
        self.h = heading
        self.w = w
        self.step_count = 0
        # self.color = random.random(), random.random(), random.random()

    # def __init__(self, maze):
    #     super(Robot, self).__init__(8, 8, heading=90)
    #     self.chose_random_direction()
    #     self.step_count = 0

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



# ------------------------------------------------------------------------

class Shark(Particle):
    speed = 0.2

    def __init__(self, maze):
        super(Shark, self).__init__(*maze.random_free_place(), heading=90)
        self.chose_random_direction()
        self.step_count = 0


    def chose_random_direction(self):
        heading = random.uniform(0, math.pi)
        self.h = heading

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
        return add_little_noise(super(Shark, self).read_distance_sensor(robot))[0]

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


def estimate(robots, shark, particles, world, error_x, error_y):

    # Initialize lists
    weight_list = [1]*len(particles)

    # Read sensors

    for i, robot in enumerate(robots):
        shark_robot_dist = shark.read_distance_sensor(robot)
        shark_robot_angle = shark.read_angle_sensor(robot)


        # Update particle weight according to how good every particle matches
        # robbie's sensor reading
        for j, p in enumerate(particles):

            particle_robot_dist = p.read_distance_sensor(robot)
            particle_robot_angle = p.read_angle_sensor(robot)


            # Calculate weight from gaussian
            error_dist_particle_robot = shark_robot_dist - particle_robot_dist
            error_angle_particle_robot = shark_robot_angle - particle_robot_angle

            weight_particle_robot = gauss(error_dist_particle_robot) * gauss(error_angle_particle_robot)

            weight_list[j] *= weight_particle_robot

    for i, p in enumerate(particles):

        p.w = weight_list[i]

    # Find the mean point and associated confidence
    m_x, m_y, m_confident = compute_mean_point(particles, world)

    # Append difference between current and estimated state to lists
    error_x.append(m_x - shark.x)
    error_y.append(m_y - shark.y)


    # Shuffle particles
    new_particles = []

    # Normalise weights
    nu = sum(p.w for p in particles)
    if nu:
        for p in particles:
            p.w = p.w / nu

    # create a weighted distribution, for fast picking
    dist = WeightedDistribution(particles)

    for _ in particles:
        p = dist.pick()
        if p is None:  # No pick b/c all totally improbable
            new_particle = Particle.create_random(1, world)[0]
        else:
            new_particle = Particle(p.x, p.y,
                    heading=robot1.h if ROBOT_HAS_COMPASS else p.h,
                    noisy=True)
        new_particles.append(new_particle)
    return new_particles

def move(world, robots, shark1, shark2, particles1, particles2):
    # ---------- Move things ----------
    for robot in robots:
        robot.move(world)
    old_heading1 = shark1.h
    shark1.move(world)
    # TODO: change to have more variance
    d_h1 = shark1.h - old_heading1

    old_heading2 = shark2.h
    shark2.move(world)
    d_h2 = shark2.h - old_heading2

    # Move particles according to my belief of movement (this may
    # be different than the real movement, but it's all I got)
    for p in particles1:
        # TODO: find a better way to disperse this (currently: 5 degree)
        p.h += random.uniform(d_h1, 0.1)  # in case robot changed heading, swirl particle heading too
        p.advance_by(shark1.speed)

    for p in particles2:
        # TODO: find a better way to disperse this (currently: 5 degree)
        p.h += random.uniform(d_h2, 0.1)  # in case robot changed heading, swirl particle heading too
        p.advance_by(shark2.speed)


def errorPlot(error_x, error_y):
    fig, axes = plt.subplots(nrows=2, ncols=1)

    axes[0].plot(error_x)
    axes[0].set_ylabel('Error in x')
    axes[0].set_title('No. of Particles : ' + str(PARTICLE_COUNT))
    axes[1].plot(error_y)
    axes[1].set_ylabel('Error in y')

    plt.show()

def show(world, robots, shark1, shark2, particles1, particles2, mean1, mean2):
    world.clearMaze()
    world.show_particles(particles1)
    world.show_particles(particles2)
    world.show_mean(mean1)
    world.show_mean(mean2)

    for robot in robots:
        world.show_robot(robot)

    world.show_shark(shark1)
    world.show_shark(shark2)


# ------------------------------------------------------------------------
def main():
    world = Maze(maze_data)

    if SHOW_VISUALIZATION:
        world.draw()

    # initial distribution assigns each particle an equal probability
    particles1 = Particle.create_random(PARTICLE_COUNT, world)
    particles2 = Particle.create_random(PARTICLE_COUNT, world)
    robots = Robot.create_random(2, world)
    sharkie = Shark(world)
    sharkette = Shark(world)

    # Initialize error lists
    error_x1 = []
    error_y1 = []
    error_x2 = []
    error_y2 = []

    # Filter for time step
    for time_step in range(TIME_STEPS):
        # TODO: consider better syntax... (make into class)
        particles1 = estimate(robots, sharkie, particles1, world, error_x1, error_y1)
        mean1 = compute_mean_point(particles1, world)

        particles2 = estimate(robots, sharkette, particles2, world, error_x2, error_y2)
        mean2 = compute_mean_point(particles2, world)

        # Move robots, sharks and particles
        move(world, robots, sharkie, sharkette, particles1, particles2)

        # Show current state
        if SHOW_VISUALIZATION:
            show(world, robots, sharkie, sharkette, particles1, particles2, mean1, mean2)

        print time_step


    # Plot actual vs. estimated into graph
    errorPlot(error_x1, error_y1)
    errorPlot(error_x2, error_y2)



if __name__ == "__main__":
    main()


