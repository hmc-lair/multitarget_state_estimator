# Read Hydrophone Measurement
import datetime
import matplotlib.pyplot as plt

def readTimeStamp(s):
    time = datetime.datetime.strptime(s, "%H:%M:%S.%f");
    return time


def main():
    # file = open('tagPing.txt','r')
    filename = 'Vemco_calibration'
    lines = [line.rstrip('\n') for line in open('vemco_data/'+ filename + '.txt')]
    time_450208 = []
    time_450207 = []
    time_elapsed_list = []

    for line in lines:
        s = line.split(',')
        if len(s) == 2:
            time = s[1]
            time_dt = readTimeStamp(time[0:15])

            if s[0] == '450208':
                time_450208.append(time_dt)
            else:
                time_450207.append(time_dt)

    time_delta_list = []

    for i,item in enumerate(time_450208):
        time_delta = item - time_450207[i]
        time_delta_list.append(time_delta.total_seconds())
        time_elapsed_dt = item - time_450208[0]
        time_elapsed_list.append(time_elapsed_dt.total_seconds())


    plt.plot(time_elapsed_list,time_delta_list, '.')
    plt.title('Hydrophone ' + filename)
    plt.ylabel('Time between Hydrophone Detections (s)')
    plt.xlabel('Time elapsed (s)')


    ax = plt.gca()
    ax.ticklabel_format(useOffset=False)
    plt.savefig(filename)

    plt.show()

    # Write to data file
    w_file = open('timeDiff'+filename + '.txt', 'w')
    for i,item in enumerate(time_delta_list):
        w_file.write("%s,%s\n" % (time_elapsed_list[i],item))

    # print time_delta_list



if __name__ == "__main__":
    main()






