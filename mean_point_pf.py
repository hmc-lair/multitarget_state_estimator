
from __future__ import absolute_import

import numpy as np
import matplotlib.pyplot as plt
import individual_particle_filter as pf
import shark_particle as sp


TIME_STEPS = 100
SIGMA_MEAN = 0.5
MOVING_DATA = 25
# ------------------------------------------------------------------------

def moving_average(data, number_points):
    """ Computes the moving average of data using number_points of last data.
    """
    length = len(data)
    if length < number_points:
        return sum(data)/float(length)
    else:
        return sum(data[length - number_points:])/float(number_points)


def compute_mean_position(tracked_sharks):
    """ Computes the mean position of the tracked sharks
    tracked_sharks: List of tracked sharks
    """
    m_x, m_y = 0, 0

    for shark in tracked_sharks:
        m_x += shark.x
        m_y += shark.y

    x_mean = m_x / len(tracked_sharks)
    y_mean = m_y / len(tracked_sharks)

    return x_mean, y_mean

def estimate(tracked_sharks, particles, world):

    # Initialize lists
    weight_list = [1]*len(particles)

    # "Measure" mean position, assuming perfect location
    x_mean, y_mean = compute_mean_position(tracked_sharks)

    # Update particle weight according to how good every particle matches
    for j, p in enumerate(particles):
        error_xmean = x_mean - p.x
        error_ymean = y_mean - p.x

        weight_particle = pf.gauss(error_xmean) * pf.gauss(error_ymean)
        weight_list[j] *= weight_particle

    for i, p in enumerate(particles):

        p.w = weight_list[i]

    # Shuffle particles
    new_particles = []

    # Normalise weights
    nu = sum(p.w for p in particles)
    if nu:
        for p in particles:
            p.w = p.w / nu

    # create a weighted distribution, for fast picking
    dist = pf.WeightedDistribution(particles)

    for _ in particles:
        p = dist.pick()
        if p is None:  # No pick b/c all totally improbable
            new_particle = pf.Particle.create_random(1, world)[0]
        else:
            new_particle = pf.Particle(p.x, p.y,
                    heading=robot1.h if pf.ROBOT_HAS_COMPASS else p.h,
                    noisy=True)
        new_particles.append(new_particle)
    return new_particles

def move(world, robots, sharks, particles_list, sigma_rand, k_att, k_rep):
    # ---------- Move things ----------
    for robot in robots:
        robot.move(world)

    d_h = []
    for shark in sharks:
        old_heading = shark.h
        # shark.move(world)
        shark.advance(sharks, shark.speed, sigma_rand, k_att, k_rep)
        d_h.append(shark.h - old_heading)


    # Move particles according to my belief of movement (this may
    # be different than the real movement, but it's all I got)
    for i, particles in enumerate(particles_list):

        for p in particles:
            # TODO: find a better way to disperse this (currently: 5 degree)
            # p.h += np.random.normal(0, 1)
            p.x += np.random.normal(0, SIGMA_MEAN)
            p.y += np.random.normal(0, SIGMA_MEAN)
            # p.h += random.uniform(d_h[i], 0.1)  # in case robot changed heading, swirl particle heading too
            # p.advance_by(2)

def main():
    world = pf.Maze(pf.MAZE_DATA)

    if pf.SHOW_VISUALIZATION:
        world.draw()

    # Initialize Items
    sharks = pf.Shark.create_random(pf.SHARK_COUNT, world, pf.SHARK_COUNT)
    robots = pf.Robot.create_random(pf.ROBOT_COUNT, world)
    particles_list = [pf.Particle.create_random(pf.PARTICLE_COUNT, world)]

    [(x_att, y_att)] = sp.ATTRACTORS

    dist_mean_list = []
    dist_mov_mean_list = []
    x_mean_list = []
    y_mean_list = []

    for time_step in range(TIME_STEPS):

        # Calculate mean position
        # TODO: change to less sharks
        p_means_list = []
        x_mean, y_mean = compute_mean_position(sharks)
        dist_mean_list.append(np.hypot(x_mean - x_att, y_mean - y_att))
        x_mean_list.append(x_mean)
        y_mean_list.append(y_mean)

        # Moving Average
        x_mov_mean = moving_average(x_mean_list, MOVING_DATA)
        y_mov_mean = moving_average(y_mean_list, MOVING_DATA)
        dist_mov_mean_list.append(np.hypot(x_mov_mean - x_att, y_mov_mean - y_att))

        #
        for i, particles in enumerate(particles_list):
            particles_list[i] = estimate(sharks, particles, world)
            p_means_list.append(pf.compute_particle_mean(particles, world))


        # # ---------- Move things ----------
        # Move sharks with shark's speed
        move(world, robots, sharks, particles_list, sp.SIGMA_RAND, sp.K_ATT, sp.K_REP)

        # Show current state
        if pf.SHOW_VISUALIZATION:
            pf.show(world, robots, sharks, particles_list, p_means_list)

    plt.figure()
    plt.ylabel('Distance from Attraction Point')
    plt.xlabel('Time')
    plt.plot(dist_mean_list, label='Mean Position')
    plt.plot(dist_mov_mean_list, label='Mean Position (Moving)')
    plt.legend(loc='upper right')
    plt.show()

if __name__ == "__main__":
    main()