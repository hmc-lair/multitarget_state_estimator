__author__ = 'cherieho'
import particle_filter as pf
import shark_particle as sp
import numpy as np
import math
import matplotlib.pyplot as plt
import sys
import random


# Constants

PARTICLE_COUNT = 1   # Total number of particles
TIME_STEPS = 10000 # Number of steps before simulation ends
SHARK_COUNT = 10 # Number of sharks
ROBOT_COUNT = 2 # Number of robots
TRACK_COUNT = 0 # Number of tracked sharks

SHOW_VISUALIZATION = False # Whether to have visualization

ROBOT_HAS_COMPASS = False


def checkChangeHeading(sigma_rand, angle_radius_factor, shark_count, k_att=sp.K_ATT, k_rep=sp.K_REP):
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
                    # Add normalized deltaAng
                    deltaAng.append(math.degrees(pf.angle_diff(shark.last_alpha, alpha)))
                shark.in_zone = True
                shark.last_alpha = alpha

            else:
                shark.in_zone = False
        # Move robots, sharks and particles
        pf.move(world, robots, sharks, particles_list, sigma_rand, k_att, k_rep)

        # Show current state
        if SHOW_VISUALIZATION:
            #TODO: should have a default state
            means_list = [(0,0,0)]
            pf.show(world, robots, sharks, particles_list, means_list)

    return deltaAng
def checkAngleAndDistanceInsideZone(sigma_rand, angle_radius_factor, shark_count, k_att=sp.K_ATT, k_rep=sp.K_REP):
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

            if np.hypot(shark.x - x_att, shark.y - y_att) < angle_radius_factor * sp.FISH_INTERACTION_RADIUS:


                alpha = math.atan2(y_att - shark.y, x_att - shark.x)
                delAngle = math.degrees(pf.angle_diff(alpha, shark.h))
                deltaAng.append(delAngle)

            x_mean = m_x/shark_count
            y_mean = m_y/shark_count
            dist_mean.append(np.hypot(x_mean - x_att, y_mean - y_att))

        # Move robots, sharks and particles
        pf.move(world, robots, sharks, particles_list, sigma_rand, k_att, k_rep)

        # Show current state
        if SHOW_VISUALIZATION:
            pf.show(world, robots, sharks, particles_list, means_list)

    return deltaAng, dist_mean

def checkIndiDistance(sigma_rand, shark_count, k_att=sp.K_ATT, k_rep=sp.K_REP):
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

    dist = []

    # Filter for time step
    for time_step in range(TIME_STEPS):

        for shark in sharks:
            dist.append(np.hypot(shark.x - x_att, shark.y - y_att))

        # Move robots, sharks and particles
        pf.move(world, robots, sharks, particles_list, sigma_rand, k_att, k_rep)

        # Show current state
        if SHOW_VISUALIZATION:
            pf.show(world, robots, sharks, particles_list, means_list)

    return dist

def checkAngleAndDistance(sigma_rand, angle_radius_factor, shark_count, k_att=sp.K_ATT, k_rep=sp.K_REP):
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
        pf.move(world, robots, sharks, particles_list, sigma_rand, k_att, k_rep)

        # Show current state
        if SHOW_VISUALIZATION:
            pf.show(world, robots, sharks, particles_list, means_list)

    return deltaAng, dist_mean

def plotHistogram(deltaAng, dist_mean, sigma_rand, angle_radius_factor, shark_count):
    if len(deltaAng) > 0:
        deltaAngMean = np.mean(deltaAng)
        deltaAngSD = np.std(deltaAng)
        bins = np.linspace(-180, 180, 100)
        plt.hist(deltaAng,bins)
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
        plt.title('S: %s, TS: %s, SR %s, ARF %s, Mean %s, SD %s' %(shark_count, TIME_STEPS, math.degrees(sigma_rand), angle_radius_factor, deltaDistMean, deltaDistSD))
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

def plotNormalizedHistogram(deltaAng, shark_count, bins):
    if len(deltaAng) > 0:
        hist, bins = np.histogram(deltaAng, bins)
        normHist = [histX/shark_count for histX in hist]
        plt.plot(bins[:-1], normHist, label=shark_count)

def plotHistogram(data, independent_variable, bins):
    if len(data) > 0:
        hist, bins = np.histogram(data, bins)
        plt.plot(bins[:-1], hist, label=independent_variable)
def varyKatt():
    ##  plot for change in heading
    plt.figure()
    bins = np.linspace(-15, 15, 500)
    arf = 1.5
    sigma_rand = 0
    shark_count = 10
    k_att_range = np.linspace(0.0000001,0.00001,10)
    # # # Varying k_att
    for k_att in k_att_range:
        deltaAng = checkChangeHeading(sigma_rand, arf, shark_count, k_att)
        plotHistogram(deltaAng, k_att, bins)
        print(k_att)

    plt.legend(loc='upper right')
    plt.title('')
    plt.title('Varying K_att, Change in Heading with TS: %s, ARF %s' % (
        TIME_STEPS, arf))
    plt.xlabel('Change in Heading')
    plt.ylabel('Occurences')
    plt.savefig('VaryKattChangeHeading_%sTS_%sSR_%sARF.png' % (
        TIME_STEPS, math.degrees(sigma_rand), arf))
    plt.close()

    # ###  plot for DelTheta
    plt.figure()
    bins = np.linspace(-10, 10, 500)
    # # # Varying k_att
    for k_att in k_att_range:
        deltaAng, dist_mean = checkAngleAndDistanceInsideZone(sigma_rand, arf, shark_count, k_att)
        plotHistogram(deltaAng, k_att, bins)
        print(k_att)

    plt.legend(loc='upper right')
    plt.title('')
    plt.title('Varying K_att, DelTheta with TS: %s, ARF %s' % (
        TIME_STEPS, arf))
    plt.xlabel('DelTheta')
    plt.ylabel('Occurences')
    plt.savefig('VaryKattDelTheta_%sTS_%sSR_%sARF.png' % (
        TIME_STEPS, math.degrees(sigma_rand), arf))
    plt.close()
    #
    # ###  plot for Change in Distance
    plt.figure()
    bins = np.linspace(0, 15, 150)
    # # # Varying Number of shark
    for k_att in k_att_range:
        deltaAng, dist_mean = checkAngleAndDistanceInsideZone(sigma_rand, arf, shark_count, k_att)
        plotHistogram(dist_mean, k_att, bins)
        print(k_att)

    plt.legend(loc='upper right')
    plt.title('')
    plt.title('Varying K_att, Distance from Att Point with TS: %s, ARF %s' % (
        TIME_STEPS, arf))
    plt.xlabel('Distance from attraction point')
    plt.ylabel('Occurences')
    plt.savefig('VaryKattDist_%sTS_%sSR_%sARF.png' % (
        TIME_STEPS, math.degrees(sigma_rand), arf))
    plt.close()

    ###  plot for Individual Distance From Att
    plt.figure()
    bins = np.linspace(0, 100, 100)
    for k_att in k_att_range:
        dist = checkIndiDistance(sigma_rand, shark_count, k_att)
        plotHistogram(dist, k_att, bins)
        print(k_att)

    plt.legend(loc='upper right')
    plt.title('')
    plt.title('Varying K_att, Individual Distance from Att Point with TS: %s' % (
        TIME_STEPS))
    plt.xlabel('Distance from attraction point')
    plt.ylabel('Occurences')
    plt.savefig('VaryKattIndiDist_%sTS_%sSR.png' % (
        TIME_STEPS, math.degrees(sigma_rand)))
    plt.close()


def varyNumberOfSharks():
    ### Normalized plot for change in heading
    # plt.figure()
    # bins = np.linspace(-15, 15, 100)
    # angle_radius_factor = 1.5
    # sigma_rand = 0
    # # # # Varying Number of shark
    # for m in range(1, 100)[::20]:
    #     deltaAng = checkChangeHeading(sigma_rand, angle_radius_factor, m)
    #     plotNormalizedHistogram(deltaAng, m, bins)
    #     print(m)
    #
    # plt.legend(loc='upper right')
    # plt.title('')
    # plt.title('Norm Change in Heading with TS: %s, ARF %s' % (
    #     TIME_STEPS, angle_radius_factor))
    # plt.xlabel('Change in Heading')
    # plt.ylabel('Normalized Occurences')
    # plt.savefig('NormChangeHeading_%sTS_%sSR_%sARF.png' % (
    #     TIME_STEPS, math.degrees(sigma_rand), angle_radius_factor))
    # plt.close()

    # ### Normalized plot for DelTheta
    # plt.figure()
    # bins = np.linspace(-10, 10, 100)
    # arf = 1.5
    # sigma_rand = 0
    # # # # Varying Number of shark
    # for m in range(1, 100)[10::20]:
    #     deltaAng, dist_mean = checkAngleAndDistanceInsideZone(sigma_rand, arf, m)
    #     plotNormalizedHistogram(deltaAng, m, bins)
    #     print(m)
    #
    # plt.legend(loc='upper right')
    # plt.title('')
    # plt.title('Norm DelTheta with TS: %s, ARF %s' % (
    #     TIME_STEPS, arf))
    # plt.xlabel('DelTheta')
    # plt.ylabel('Normalized Occurences')
    # plt.savefig('NormDelTheta_%sTS_%sSR_%sARF.png' % (
    #     TIME_STEPS, math.degrees(sigma_rand), arf))
    # plt.close()
    #
    # ### Normalized plot for Change in Distance
    # plt.figure()
    # bins = np.linspace(0, 15, 150)
    # arf = 1.5
    # sigma_rand = 0
    # # # # Varying Number of shark
    # for m in range(1, 100)[10::20]:
    #     deltaAng, dist_mean = checkAngleAndDistanceInsideZone(sigma_rand, arf, m)
    #     plotNormalizedHistogram(dist_mean, m, bins)
    #     print(m)
    #
    # plt.legend(loc='upper right')
    # plt.title('')
    # plt.title('Norm Distance from Att Point with TS: %s, ARF %s' % (
    #     TIME_STEPS, arf))
    # plt.xlabel('Distance from attraction point')
    # plt.ylabel('Normalized Occurences')
    # plt.savefig('NormDist_%sTS_%sSR_%sARF.png' % (
    #     TIME_STEPS, math.degrees(sigma_rand), arf))
    # plt.close()

    ### Normalized plot for Individual Distance From Att
    plt.figure()
    bins = np.linspace(0, 100, 100)
    sigma_rand = 0
    # # # Varying Number of shark
    for m in range(1, 100)[10::10]:
        dist = checkIndiDistance(sigma_rand, m)
        plotNormalizedHistogram(dist, m, bins)
        print(m)

    plt.legend(loc='upper right')
    plt.title('')
    plt.title('Norm Individual Distance from Att Point with TS: %s' % (
        TIME_STEPS))
    plt.xlabel('Distance from attraction point')
    plt.ylabel('Normalized Occurences')
    plt.savefig('NormIndiDist_%sTS_%sSR.png' % (
        TIME_STEPS, math.degrees(sigma_rand)))
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
    # for l in range(1, 10):
    #     angle_radius_factor = l * 0.5
    #     deltaAng = checkChangeHeading(0, angle_radius_factor, 20)
    #     plotHistogramChangeHeading(deltaAng, 0, angle_radius_factor, 20)
    # Varying ARF
    # for l in range(1, 10):
    #     angle_radius_factor = l * 0.5
    #     deltaAng = checkChangeHeading(0, angle_radius_factor, 5)
    #     plotHistogramChangeHeading(deltaAng, 0, angle_radius_factor, 5)
    # # Varying Number of shark
    # for m in range(1,100)[::10]:
    #     deltaAng = checkChangeHeading(0, 1.5, m)
    #     plotHistogramChangeHeading(deltaAng, 0, 1.5, m)
    #     print m
    ### Looking at heading and location inside zone
    # for n in range(1,100)[::10]:
    #     arf = 0.5
    #     deltaAng, dist_mean = checkAngleAndDistanceInsideZone(0, arf, n)
    #     plotHistogram(deltaAng, dist_mean, 0, arf, n)
    #     print(n)
    varyKatt()





if __name__ == "__main__":
    main()