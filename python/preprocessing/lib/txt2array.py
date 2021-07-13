
import numpy as np
from zeroInterp import zeroInterp
import matplotlib.pyplot as plt

def txt2array(dat, eyes, s_trg = 'Start_Experiment' ,normalize = False):
   
    events = {'Baseline':[],'.avi':[],'UE-keypress':[]}
    eyeData= {'Right':[],'Left':[]}
    msg_type = ['Baseline','.avi','UE-keypress']

    start = False
    # s_trg = '001Baseline.jpg'
    for line in dat:
        if start:
            if 'SMP' in line:
                # eyeData['Left'].append([float(line[0]),
                #                         float(line[7]),
                #                         float(line[17]),
                #                         float(line[18])])
                # eyeData['Right'].append([float(line[0]),
                #                          float(line[8]),
                #                          float(line[19]),
                #                          float(line[20])])
                eyeData['Left'].append([float(line[0]),
                                        float(line[5]),
                                        float(line[9]),
                                        float(line[10])])
                eyeData['Right'].append([float(line[0]),
                                         float(line[8]),
                                         float(line[11]),
                                         float(line[12])])
            for m in msg_type:
                if m in str(line[5]):
                     events[m].append([int(line[0]),line[5:]])
              
        else:
            if 'Rate:' in line:
                fs = int(line[3])
            if s_trg in line:
                start = True
                events[msg_type[0]].append([int(line[0]),line[5:]])
                initialTimeVal = int(line[0])
    
    pL = np.array([p[1] for p in eyeData['Left']])
    pR = np.array([p[1] for p in eyeData['Right']])
    
    xL = np.array([p[2] for p in eyeData['Left']])
    xR = np.array([p[2] for p in eyeData['Right']])
    
    yL = np.array([p[3] for p in eyeData['Left']])
    yR = np.array([p[3] for p in eyeData['Right']])
    
    timeStampL = np.array([int(((p[0]- initialTimeVal)/1000) / (1 / fs * 1000)) for p in eyeData['Left']])
    timeStampR = np.array([int(((p[0]- initialTimeVal)/1000) / (1 / fs * 1000)) for p in eyeData['Right']]) 
        
    # if eyes == 1: # both eyes
        
    timeLen = np.max(timeStampR) if np.max(timeStampR) > np.max(timeStampL) else np.max(timeStampL)
    
    pupilData = np.zeros((2,timeLen+1))
    pupilData[0,timeStampL] = pL
    pupilData[1,timeStampR] = pR
    
    xData = np.zeros((2,timeLen+1))
    xData[0,timeStampL] = xL
    xData[1,timeStampR] = xR
    
    yData = np.zeros((2,timeLen+1))
    yData[0,timeStampL] = yL
    yData[1,timeStampR] = yR
    
    for i in np.arange(2):
        ind = np.argwhere(abs(np.diff(pupilData[i,])) > 0.1)
        pupilData[i,ind] = 0  
    
    if normalize:
        tmp_p = abs(pupilData.copy())
        ind_nonzero = np.argwhere(tmp_p[0,:] != 0).reshape(-1)
        ave_left = np.mean(tmp_p[0,ind_nonzero])
        sigma_left = np.std(tmp_p[0,ind_nonzero])       
        ind_nonzero = np.argwhere(tmp_p[1,:] != 0).reshape(-1)
        ave_right = np.mean(tmp_p[1,ind_nonzero])
        sigma_right = np.std(tmp_p[1,ind_nonzero])       
        ave = np.mean([ave_left,ave_right])
        sigma = np.mean([sigma_left,sigma_right])
        
    pupilData = zeroInterp(pupilData.copy(),fs,10)
    interplatedArray = pupilData['interpolatedArray'][0]
    print('Interpolated array = ' + str(pupilData['interpolatedArray']) + 
          ' out of ' + str(pupilData['pupilData'].shape[1]))
    
    if (min(np.array(pupilData['interpolatedArray']))/pupilData['pupilData'].shape[1]) > 0.4:
        rejectFlag = True
    else:
        rejectFlag = False
        
    if pupilData['interpolatedArray'][0] < pupilData['interpolatedArray'][1]:
        xData = xData[0,:].reshape(-1)
        yData = yData[0,:].reshape(-1)
    else:
        xData = xData[1,:].reshape(-1)
        yData = yData[1,:].reshape(-1)
       
    if eyes == 1: 
        if pupilData['interpolatedArray'][0] < pupilData['interpolatedArray'][1]:
            pupilData = pupilData['pupilData'][0,:].reshape(1,pupilData['pupilData'].shape[1])
            useEye = 'L'
        else:
            pupilData = pupilData['pupilData'][1,:].reshape(1,pupilData['pupilData'].shape[1])
            useEye = 'R'
    else: # both eyes
        pupilData = pupilData['pupilData']
        useEye = 'both'
        
    ############ micro-saccade #########################
    dt = 1/fs
    v = np.zeros(len(xData))
    for i in np.arange(2,len(xData)-2):
        v[i] = (xData[i+2]+xData[i+1]-xData[i-2]-xData[i-1])
        # / (6*dt)
    
    for i in np.arange(2,len(xData)-2):
        if xData[i+2] * xData[i+1] * xData[i-2] * xData[i-1] == 0:
            v[i-50:i+50] = np.nan
    
    v[v>100] = np.nan
    v[xData>900] = np.nan
    v[xData<700] = np.nan
   
    # plt.figure()
    # plt.hist(v,bins=1000)
    # plt.xlim([-25, 25])
    # plt.xlim([0, 500])
    # sigma_m = np.nanmedian(v**2) - (np.nanmedian(v)**2)
    sigma_m = np.nanstd(v)
    ramda = 2
    upsilon = ramda*sigma_m
    # if upsilon > 10:
    #     upsilon=6
    # print('th = ' + str(upsilon))
    # print('std = ' + str(np.nanstd(v)))
    
    # plt.figure()
    # plt.subplot(1,3,1)
    # plt.plot(v)
    # # plt.plot((xData-np.mean(xData))*0.1-5)
    # plt.hlines(upsilon, 0, len(xData), "red", linestyles='dashed')
    # plt.xlim([200000, 205000])
    # plt.ylim([-10, 20])
   
    ind = np.argwhere(abs(v) > upsilon)
    rejectNum = []
    for i in np.arange(len(ind)-1):
        if ind[i+1] == ind[i]+1:
            rejectNum.append(i+1)
    
    ind = np.delete(ind,rejectNum,axis=0)
    mSaccade = np.zeros(len(xData))
    mSaccade[ind] = v[ind]
            
    ############ data plot #########################
    pupilData = np.mean(pupilData,axis=0)
    
    # plt.subplot(1,3,2)
    # plt.plot(pupilData.T)
    # plt.xlim([200000, 210000])
    # # plt.ylim([20000,10000])
    
    # plt.subplot(1,3,3)
    # plt.plot(np.diff(pupilData).T)
    # plt.xlim([200000, 210000])
    # plt.ylim([-50,50])
    
    if normalize:
        pupilData = (pupilData - ave) / sigma
    eyeData = {'pupilData':pupilData,
               'gazeX':xData,
               'gazeY':yData,
               'mSaccade':mSaccade,
               'useEye':useEye,
               'rejectFlag':rejectFlag
               }
    return eyeData,events,initialTimeVal,int(fs)