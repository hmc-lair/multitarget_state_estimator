""" Visualize Matlab Shark Trajectories.

Author: Cherie Ho
"""
import scipy.io as sio
from draw_shark import Maze

# Constants
WIDTH = 10
HEIGHT = 10
SHOW_VISUALIZATION = True


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
        self.x_list = x_list
        self.y_list = y_list
        self.t_list = t_list

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

    def update(self, timestep):
        self.x = self.x_list[timestep]
        self.y = self.y_list[timestep]
        self.h = self.h_list[timestep]

class Shark(Particle):

    def __init__(self, x, y, tracked=False, heading=None, w=1):
        if heading is None:
            heading = random.uniform(- math.pi, math.pi)

        self.x = 0
        self.y = 0
        self.h = heading
        self.tracked = tracked
        self.w = w
        self.step_count = 0
        self.color = random.random(), random.random(), random.random()

    def __repr__(self):
        return "(%f, %f, w=%f, tracked=%r)" % (self.x, self.y, self.w, self.tracked)
    @classmethod
    def create_random(cls, count, maze, track_count):
        return [cls(*maze.random_free_place(), tracked=True if i<track_count else False) for i in range(0, count)]

    def distance(self, shark):
        return math.sqrt((self.x - shark.x) ** 2 + (self.y - shark.y) ** 2)


    def update(self, ):
        """
        :param
                k_att: Attraction Gain
                k_rep: Repulsive Gain
        :return: Advance shark by one step.
        """
        # Get attributes
        x_att, y_att = self.find_attraction(sp.ATTRACTORS)
        x_rep, y_rep = self.find_repulsion(sharks)

        # Sum all potentials
        x_tot = k_att * x_att + k_rep * x_rep
        y_tot = k_att * y_att + k_rep * y_rep
        desired_theta = math.atan2(y_tot, x_tot)

        # Set yaw control
        control_theta = sp.K_CON * (self.angle_diff(desired_theta)) + sigma_rand * np.random.randn(1)[0]
        control_theta = min(max(control_theta, - sp.MAX_CONTROL), sp.MAX_CONTROL)
        self.h += control_theta

        # Calculate cartesian distance
        dx = math.cos(self.h) * speed
        dy = math.sin(self.h) * speed

        # Checks if, after advancing, shark is still in the box
        if checker is None or checker(self, dx, dy):
            self.move_by(dx, dy)
            return True
        return False



mat_contents = sio.loadmat('fishSim/fishSimData.mat')

t = mat_contents['t']
x = mat_contents['x']
y = mat_contents['y']

print x[1]
print len(x[1])

world = Maze(WIDTH, HEIGHT)

if SHOW_VISUALIZATION:
    world.draw()