""" Visualize Matlab Shark Trajectories.

Author: Cherie Ho
"""
import scipy.io as sio
from draw import Maze
import shark_particle as sp
import random
import att_line_pf as att_pf
import numpy as np

# Constants
HALF_WIDTH = 15
HALF_HEIGHT = 15
SHOW_VISUALIZATION = True
TIME_STEPS = 800
maze_data = ((1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
             (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
PARTICLE_COUNT = 50
SIGMA_MEAN = 0.1

class Shark(sp.Particle):

    def __init__(self, x_list, y_list, t_list, tracked=False, w=1):

        self.color = random.random(), random.random(), random.random()
        self.x_list = x_list
        self.y_list = y_list
        self.t_list = t_list
        self.x = self.x_list[0]
        self.y = self.y_list[0]
        self.h = self.t_list[0]
        self.tracked = tracked
        self.w = w
        self.step_count = 0


    def __repr__(self):
        return "(%f, %f, w=%f, tracked=%r)" % (self.x, self.y, self.w, self.tracked)

    @classmethod
    def create_random(cls, count, maze, x_lol, y_lol, t_lol, track_count):
        return [cls(x_lol[i], y_lol[i], t_lol[i], tracked=True if i<track_count else False) for i in range(0, count)]

    def distance(self, shark):
        return math.sqrt((self.x - shark.x) ** 2 + (self.y - shark.y) ** 2)

    def update(self, timestep):
        self.x = self.x_list[timestep]
        self.y = self.y_list[timestep]
        self.h = self.t_list[timestep]



def move(world, sharks, particles_list, timestep):
    # ---------- Move things ----------
    for shark in sharks:
        shark.update(timestep)

    for i, particles in enumerate(particles_list):

        for p in particles:
            p.x1 += np.random.normal(0, SIGMA_MEAN)
            p.y1 += np.random.normal(0, SIGMA_MEAN)

            p.x2 += np.random.normal(0, SIGMA_MEAN)
            p.y2 += np.random.normal(0, SIGMA_MEAN)



def main():
    mat_contents = sio.loadmat('tracks.mat')

    t_LoL = mat_contents['t']
    x_LoL = mat_contents['x']
    y_LoL = mat_contents['y']


    num_sharks = len(x_LoL)
    time_steps = len(x_LoL[0])

    # Initialize Objects
    world = Maze(maze_data, HALF_WIDTH, HALF_HEIGHT)
    if SHOW_VISUALIZATION:
        world.draw()
    sharks = Shark.create_random(num_sharks, world, x_LoL, y_LoL, t_LoL, num_sharks)
    robots = sp.Robot.create_random(0, world)
    particles_list = [sp.Particle.create_random(PARTICLE_COUNT, world)]

    # Actual Line (from Kim)
    # y = -0.2168x + 0.113
    act_line_start = (-HALF_WIDTH, -0.2168*-HALF_WIDTH + 0.113)
    act_line_end = (HALF_WIDTH, -0.2168* HALF_WIDTH + 0.113)
    act_att_line = att_pf.LineString([act_line_start, act_line_end])

    # Initialize error lists and file
    my_file = open("catalina_error.txt", "w")
    error_list = []

    for time_step in range(TIME_STEPS):
        # TODO: Consolidate shark_sim.py and att_line_pf.py
        # Calculate mean position
        p_means_list = []

        for i, particles in enumerate(particles_list):
            particles_list[i] = att_pf.estimate(particles, world, sharks)

        m1, m2 = att_pf.compute_particle_means(particles, world)
        # TODO
        p_means_list.append(m1)

        move(world, sharks, particles_list, time_step)

        # Find total error (performance metric) and add to list
        est_line = att_pf.LineString([m1, m2])

        est_error_sum = 0
        act_error_sum = 0
        raw_error_sum = 0

        for shark in sharks:
            est_error_sum += ((att_pf.distance_from_line(shark, est_line))) ** 2
            act_error_sum += ((att_pf.distance_from_line(shark, act_att_line))) ** 2
            # raw_error_sum += (distance_from_line(shark, est_line) - distance_from_line(shark, attraction_line))**2

        # error = math.sqrt(raw_error_sum/track_count)
        est_error = att_pf.math.sqrt(est_error_sum / num_sharks)
        act_error = att_pf.math.sqrt(act_error_sum / num_sharks)

        error_list.append(est_error)
        error_list.append(act_error)


        #
        # ---------- Show current state ----------
        if SHOW_VISUALIZATION:
            sp.show(world, robots, sharks, particles_list, p_means_list, m1, m2, act_att_line)

        print time_step

    for item in error_list:
        my_file.write(str(item) + ",")
    my_file.write("\n")
    my_file.close()





if __name__ == "__main__":
    main()