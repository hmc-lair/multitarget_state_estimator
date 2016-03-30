__author__ = 'cherieho'
import particle_filter as pf
import shark_particle as sp
import numpy as np
import math
import matplotlib.pyplot as plt
import sys


# Constants

PARTICLE_COUNT = 1   # Total number of particles
TIME_STEPS = 10000 # Number of steps before simulation ends
SHARK_COUNT = 10 # Number of sharks
ROBOT_COUNT = 2 # Number of robots
TRACK_COUNT = 0 # Number of tracked sharks

SHOW_VISUALIZATION = False # Whether to have visualization

ROBOT_HAS_COMPASS = False


def checkChangeHeading(sigma_rand, angle_radius_factor, shark_count):
    world = pf.Maze(sp.maze_data)

    if SHOW_VISUALIZATION:
        world.draw()

    # Initialize particles, robots, means and sharks
    particles_list = []
    for _ in range(TRACK_COUNT):
        particles_list.append(pf.Particle.create_random(PARTICLE_COUNT, world))
    robots = pf.Robot.create_random(ROBOT_COUNT, world)
    sharks = pf.Shark.create_random(shark_count, world, TRACK_COUNT)
    [(x_att, y_att)] = sp.ATTRACTORS

    deltaAng = []
    # Filter for time step
    for time_step in range(TIME_STEPS):
        for shark in sharks:

            if np.hypot(shark.x - x_att, shark.y - y_att) < angle_radius_factor * sp.FISH_INTERACTION_RADIUS:
                alpha = math.atan2(y_att - shark.y, x_att - shark.x)
                if shark.in_zone:
                    deltaAng.append(math.degrees(pf.angle_diff(shark.last_alpha, alpha)))
                shark.in_zone = True
                shark.last_alpha = alpha

            else:
                shark.in_zone = False
        # Move robots, sharks and particles
        pf.move(world, robots, sharks, particles_list, sigma_rand)

        # Show current state
        if SHOW_VISUALIZATION:
            pf.show(world, robots, sharks, particles_list, means_list)

    return deltaAng

def checkAngleAndDistance(sigma_rand, angle_radius_factor, shark_count):
    world = pf.Maze(sp.maze_data)

    if SHOW_VISUALIZATION:
        world.draw()

    # Initialize particles, robots, means and sharks
    particles_list = []
    for _ in range(TRACK_COUNT):
        particles_list.append(pf.Particle.create_random(PARTICLE_COUNT, world))
    robots = pf.Robot.create_random(ROBOT_COUNT, world)
    sharks = pf.Shark.create_random(shark_count, world, TRACK_COUNT)

    [(x_att, y_att)] = sp.ATTRACTORS

    deltaAng = []
    dist_mean = []

    # Filter for time step
    for time_step in range(TIME_STEPS):

        means_list = []
        m_x, m_y = 0, 0

        for shark in sharks:

            m_x += shark.x
            m_y += shark.y

            if np.hypot(shark.x - x_att, shark.y - y_att) > angle_radius_factor * sp.FISH_INTERACTION_RADIUS:


                alpha = math.atan2(y_att - shark.y, x_att - shark.x)
                delAngle = math.degrees(pf.angle_diff(alpha, shark.h))
                deltaAng.append(delAngle)

            x_mean = m_x/shark_count
            y_mean = m_y/shark_count
            dist_mean.append(np.hypot(x_mean - x_att, y_mean - y_att))

        # Move robots, sharks and particles
        pf.move(world, robots, sharks, particles_list, sigma_rand)

        # Show current state
        if SHOW_VISUALIZATION:
            pf.show(world, robots, sharks, particles_list, means_list)

    return deltaAng, dist_mean

def plotHistogram(deltaAng, dist_mean, sigma_rand, angle_radius_factor, shark_count):
    if len(deltaAng) > 0:
        deltaAngMean = np.mean(deltaAng)
        deltaAngSD = np.std(deltaAng)
        plt.hist(deltaAng)
        plt.title('')
        plt.title('S: %s, TS: %s, SR %s, ARF %s, Mean %s, SD %s' %(shark_count, TIME_STEPS, math.degrees(sigma_rand), angle_radius_factor, deltaAngMean, deltaAngSD))
        plt.xlabel('DelAngle')
        plt.ylabel('Occurences')
        plt.savefig('Angle_%sSharks_%sTS_%sSR_%sARF.png'%(shark_count, TIME_STEPS, math.degrees(sigma_rand), angle_radius_factor))
        plt.close()

    if len(dist_mean) > 0:
        deltaDistMean = np.mean(dist_mean)
        deltaDistSD = np.std(dist_mean)
        plt.hist(dist_mean)
        plt.title('')
        plt.title('S: %s, TS: %s, SR %s, ARF %s, Mean %s, SD %s' %(SHARK_COUNT, TIME_STEPS, math.degrees(sigma_rand), angle_radius_factor, deltaDistMean, deltaDistSD))
        plt.xlabel('Distance from Attraction Point')
        plt.ylabel('Occurences')
        plt.savefig('Distance_%sSharks_%sTS_%sSR_%sARF.png'%(shark_count, TIME_STEPS, math.degrees(sigma_rand), angle_radius_factor))
        plt.close()

def plotHistogramChangeHeading(deltaAng, sigma_rand, angle_radius_factor, shark_count):
    if len(deltaAng) > 0:
        deltaAngMean = np.mean(deltaAng)
        deltaAngSD = np.std(deltaAng)
        bins = np.linspace(-10, 10, 100)
        plt.hist(deltaAng, bins)
        plt.title('')
        plt.title('S: %s, TS: %s, SR %s, ARF %s, Mean %s, SD %s' % (
        shark_count, TIME_STEPS, math.degrees(sigma_rand), angle_radius_factor, deltaAngMean, deltaAngSD))
        plt.xlabel('Change in Angle')
        plt.ylabel('Occurences')
        plt.savefig('ChangeAngle_%sSharks_%sTS_%sSR_%sARF.png' % (
        shark_count, TIME_STEPS, math.degrees(sigma_rand), angle_radius_factor))
        plt.close()

def main():
    # Varying Sigma rand
    # for i in range(10):
    #     sigma_rand = i * math.radians(1) + math.radians(-5)
    #     checkAngleAndDistance(sigma_rand, 4)

    # Varying ARF
    # for j in range(10):
    #     # Vary angle radius * 0:0.5:5
    #     angle_radius_factor = j * 0.5
    #     deltaAng, dist_mean = checkAngleAndDistanceWithSigma(0, angle_radius_factor, 10)
    #     plotHistogram(deltaAng, dist_mean, 0, angle_radius_factor, 10)
    #     print j

    # Varying no. of sharks
    # for k in range(1,100)[::10]:
    #     checkAngleAndDistance(0, 4, k)
    #     print k

    ##### Looking at change in heading
    # # Varying ARF
    # for l in range(1,10):
    #     angle_radius_factor = l * 0.5
    #     deltaAng = checkChangeHeading(0, angle_radius_factor, 10)
    #     plotHistogramChangeHeading(deltaAng, 0, angle_radius_factor, 10)

    # Varying ARF
    for l in range(1, 10):
        angle_radius_factor = l * 0.5
        deltaAng = checkChangeHeading(0, angle_radius_factor, 20)
        plotHistogramChangeHeading(deltaAng, 0, angle_radius_factor, 20)
    # # Varying Number of shark
    # for m in range(1,100)[::10]:
    #     deltaAng = checkChangeHeading(0, 1.5, m)
    #     plotHistogramChangeHeading(deltaAng, 0, 1.5, m)
    #     print m





if __name__ == "__main__":
    main()