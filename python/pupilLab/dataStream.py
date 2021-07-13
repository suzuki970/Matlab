from time import sleep
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import patches
from matplotlib import animation

from pylsl import StreamInfo, StreamInlet, resolve_streams

def pick_ch_names(info):
    ch_xml = info.desc().child('channels').child('channel')
    ch_names = []
    for _ in range(info.channel_count()):
        ch_names.append(ch_xml.child_value('label'))
        ch_xml = ch_xml.next_sibling()
    return ch_names

streams = resolve_streams(wait_time=3.)
inlet = StreamInlet(streams[0])

ch_names = pick_ch_names(inlet.info())
ind = np.argwhere(np.array(ch_names) == 'diameter0_3d').reshape(-1)

inlet.open_stream()
sleep(0.1)
print('START!')
#while True:
diameterR = []
x = []
for i in np.arange(100):
    dat = inlet.pull_chunk(max_samples=1024)
    try:
#        print('Confidence = ' + str(round(np.array(dat[0])[-1, 0],2)))
#        if not np.isnan(np.array(dat[0])[-1, ind]):
        diameterR.append(round(float(np.array(dat[0])[-1, ind]),2))
        x.append(i)
#        print('Pupil_R = ' + str(diameterR))
#        if not np.isnan(np.array(dat[0])[-1, ind+1]):
#        print('Pupil_L = ' + str(round(float(np.array(dat[0])[-1, ind+1]),2)))
    except:
        pass
    sleep(0.1)
    plt.cla()
    plt.plot(x,diameterR)
#    c = patches.Circle(xy=(0,0), radius=diameter/2)
#    ax.add_patch(c)
    plt.xlim([0, 10])
    plt.ylim([3, 7])
    plt.pause(.1)