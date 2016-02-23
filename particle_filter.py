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
TIME_STEPS = 50 # Number of steps before simulation ends

SHOW_VISUALIZATION = False # Whether to have visualization

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

    def __init__(self, maze):
        super(Robot, self).__init__(8, 8, heading=90)
        self.chose_random_direction()
        self.step_count = 0

    def chose_random_direction(self):
        heading = random.uniform(0, math.pi)
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
        return add_little_noise(super(Shark, self).read_distance_sensor(robot))

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
world = Maze(maze_data)

if SHOW_VISUALIZATION:
    world.draw()

# initial distribution assigns each particle an equal probability
particles = Particle.create_random(PARTICLE_COUNT, world)
robbie = Robot(world)
sharkie = Shark(world)
robert = Robot(world)

# Initialize list for plotting
error_x = []
error_y = []

for timestep in range(TIME_STEPS):
    # Read robbie's sensor
    # robot_wall_dist = robbie.read_sensor(world)
    shark_dist_robot1 = sharkie.read_distance_sensor(robbie)[0]
    shark_angle_robot1 = sharkie.read_angle_sensor(robbie)
    shark_dist_robot2 = sharkie.read_distance_sensor(robert)[0]
    shark_angle_robot2 = sharkie.read_angle_sensor(robert)


    # Update particle weight according to how good every particle matches
    # robbie's sensor reading
    for p in particles:
        # if world.is_free(*p.xy):
        # p.xyh = sharkie.xyh
        particle_dist_robot1 = p.read_distance_sensor(robbie)
        particle_angle_robot1 = p.read_angle_sensor(robbie)
        particle_dist_robot2 = p.read_distance_sensor(robert)
        particle_angle_robot2 = p.read_angle_sensor(robert)
        # Calculate weight from gaussian
        error_dist_robot1 = shark_dist_robot1 - particle_dist_robot1
        error_angle_robot1 = shark_angle_robot1 - particle_angle_robot1
        error_dist_robot2 = shark_dist_robot1 - particle_dist_robot1
        error_angle_robot2 = shark_angle_robot1 - particle_angle_robot1

        p.w = gauss(error_dist_robot1) * gauss(error_angle_robot1) * \
              gauss(error_dist_robot2) * gauss(error_angle_robot2)
        # else: # If particle not in boundary
        #     p.w = 0

    # ---------- Try to find current best estimate for display ----------
    m_x, m_y, m_confident = compute_mean_point(particles)

    # Append difference between current and estimated state to lists
    error_x.append(m_x - sharkie.x)
    error_y.append(m_y - sharkie.y)


    # ---------- Show current state ----------
    if SHOW_VISUALIZATION:
        world.show_particles(particles)
        world.show_mean(m_x, m_y, m_confident)
        world.show_robot(robbie)
        world.show_shark(sharkie)
        world.show_robot(robert)

    # ---------- Shuffle particles ----------
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
                    heading=robbie.h if ROBOT_HAS_COMPASS else p.h,
                    noisy=True)
        new_particles.append(new_particle)

    particles = new_particles

    # ---------- Move things ----------
    old_heading = sharkie.h
    robbie.move(world)
    sharkie.move(world)
    robert.move(world)
    # TODO: change to have more variance
    d_h = sharkie.h - old_heading

    # Move particles according to my belief of movement (this may
    # be different than the real movement, but it's all I got)
    for p in particles:
        # TODO: find a better way to disperse this
        p.h += random.uniform(d_h, 0.02)  # in case robot changed heading, swirl particle heading too
        p.advance_by(sharkie.speed)

    print timestep



# Plot actual vs. estimated into graph

fig, axes = plt.subplots(nrows=2, ncols=1)

axes[0].plot(error_x)
axes[0].set_ylabel('Error in x')
axes[0].set_title('No. of Particle: ' + str(PARTICLE_COUNT))
axes[1].plot(error_y)
axes[1].set_ylabel('Error in y')

plt.show()