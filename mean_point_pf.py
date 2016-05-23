from __future__ import absolute_import

import numpy as np
import matplotlib.pyplot as plt
import individual_particle_filter as pf
import shark_particle as sp

TIME_STEPS = 5000
SIGMA_MEAN = 0.1
SHOW_VISUALIZATION = True  # Whether to have visualization


# ------------------------------------------------------------------------


def moving_average(data, number_points):
    """ Computes the moving average of data using number_points of last data.
    """
    length = len(data)
    if length < number_points:
        return sum(data) / float(length)
    else:
        return sum(data[length - number_points:]) / float(number_points)


def compute_mean_position(sharks, track_number):
    """ Computes the mean position of the tracked sharks
    tracked_sharks: List of tracked sharks
    """
    m_x, m_y = 0, 0

    for shark in sharks[:track_number]:
        m_x += shark.x
        m_y += shark.y

    x_mean = m_x / track_number
    y_mean = m_y / track_number

    return x_mean, y_mean


def estimate(particles, world, x_mean, y_mean, error_x_list, error_y_list, x_att, y_att):
    # Update particle weight according to how good every particle matches
    for j, p in enumerate(particles):
        error_xmean = x_mean - p.x
        error_ymean = y_mean - p.y

        weight_particle = pf.gauss(error_xmean) * pf.gauss(error_ymean)
        p.w = weight_particle

    # Find the particle mean point and associated confidence
    m_x, m_y, m_confident = pf.compute_particle_mean(particles, world)
    error_x_list.append(m_x - x_att)
    error_y_list.append(m_y - y_att)

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


def errorIndividualPlot(error_x, error_y):
    """ Save error_x and error_y plot to current folder.

    :param error_x: Error in x direction
    :param error_y: Error in y direction
    :return: Shows error plots
    """
    fig, axes = plt.subplots(nrows=2, ncols=1)

    axes[0].plot(error_x)
    axes[0].set_ylabel('Error in x')
    axes[0].set_title(
        'No. of Particles : %s, Tracked Sharks: %s of %s' % (pf.PARTICLE_COUNT, pf.TRACK_COUNT, pf.SHARK_COUNT))
    axes[0].set_ylim([-2, 2])
    axes[1].plot(error_y)
    axes[1].set_ylabel('Error in y')
    axes[1].set_ylim([-2, 2])

    plt.savefig('MeanPointPF%sParticles%s of %sTrackedSharks.png' % (pf.PARTICLE_COUNT, pf.TRACK_COUNT, pf.SHARK_COUNT))
    plt.close()

def errorPlot(error_x, error_y, track_count):
        """ Plot error_x and error_y

        :param error_x: Error in x direction
        :param error_y: Error in y direction
        :return: Plots error
        """
        axes[0].plot(error_x, label=track_count)
        axes[1].plot(error_y, label=track_count)


def move(world, robots, sharks, particles_list, sigma_rand, k_att, k_rep):
    # ---------- Move things ----------
    for robot in robots:
        robot.move(world)

    d_h = []
    for shark in sharks:
        old_heading = shark.h
        shark.advance(sharks, shark.speed, sigma_rand, k_att, k_rep)
        d_h.append(shark.h - old_heading)

    # Move particles according to my belief of movement (this may
    # be different than the real movement, but it's all I got)
    for i, particles in enumerate(particles_list):

        for p in particles:
            p.x += np.random.normal(0, SIGMA_MEAN)
            p.y += np.random.normal(0, SIGMA_MEAN)



def run(shark_count, track_count, my_file):
    """ Run particle filter with shark_count of sharks with track_count tracked.
    """
    world = pf.Maze(pf.MAZE_DATA)

    if SHOW_VISUALIZATION:
        world.draw()

    # Initialize Items
    sharks = pf.Shark.create_random(shark_count, world, track_count)
    robots = pf.Robot.create_random(0, world)
    particles_list = [pf.Particle.create_random(pf.PARTICLE_COUNT, world)]

    [(x_att, y_att)] = sp.ATTRACTORS

    # Initialize error lists
    error_x_list = []
    error_y_list = []



    for time_step in range(TIME_STEPS):

        # Calculate mean position
        p_means_list = []
        x_mean, y_mean = compute_mean_position(sharks, track_count)

        for i, particles in enumerate(particles_list):
            particles_list[i] = estimate(particles, world, x_mean, y_mean, error_x_list, error_y_list, x_att, y_att)
            p_means_list.append(pf.compute_particle_mean(particles, world))

        # # ---------- Move things ----------
        # Move sharks with shark's speed
        move(world, robots, sharks, particles_list, sp.SIGMA_RAND, sp.K_ATT, sp.K_REP)

        #TODO: Let p_means be shark mean for now

        # Show current state
        if SHOW_VISUALIZATION:
            pf.show(world, robots, sharks, particles_list, p_means_list)

        # print(time_step)
        print "Mean Position", x_mean, y_mean


    for item in error_x_list:
        my_file.write(str(item) + ",")
    my_file.write("\n")

    for item in error_y_list:
        my_file.write(str(item) + ",")
    my_file.write("\n")


def main():
    shark_count = 50
    num_trials = 1

    # Export shark mean position over time into text file, can be plotted with matlab
    global my_file
    my_file = open("testError%s_0516.txt" %(shark_count), "w")

    for _ in range(num_trials):
        run(shark_count, shark_count, my_file)


    my_file.close()





if __name__ == "__main__":
    main()
