""" Visualize Matlab Shark Trajectories.

Author: Cherie Ho
"""
import scipy.io as sio
from draw import Maze
import shark_particle as sp
import random

# Constants
HALF_WIDTH = 15
HALF_HEIGHT = 15
SHOW_VISUALIZATION = True
TIME_STEPS = 1000
maze_data = ((1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
             (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))

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



def move(world, sharks, timestep):
    # ---------- Move things ----------
    for shark in sharks:
        shark.update(timestep)

def main():
    mat_contents = sio.loadmat('tracks.mat')

    t_LoL = mat_contents['t']
    x_LoL = mat_contents['x']
    y_LoL = mat_contents['y']

    world = Maze(maze_data, HALF_WIDTH, HALF_HEIGHT)
    num_sharks = len(x_LoL)
    time_steps = len(x_LoL[0])

    if SHOW_VISUALIZATION:
        world.draw()

    sharks = Shark.create_random(num_sharks, world, x_LoL, y_LoL, t_LoL, num_sharks)


    robert = sp.Robot(world, 0, 0)


    for time_step in range(TIME_STEPS):
        #
        # ---------- Show current state ----------
        if SHOW_VISUALIZATION:
            world.show_sharks(sharks)
            world.show_robot(robert)

        move(world, sharks, time_step)



if __name__ == "__main__":
    main()