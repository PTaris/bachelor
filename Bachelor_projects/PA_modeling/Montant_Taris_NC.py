# -*- coding: utf-8 -*-
"""
Created on Tue Jan 31 09:43:52 2023

@author: Charline Montant et Pauline Taris
"""

import numpy as np
import matplotlib.pyplot as plt

#QUESTION 1

data_tonic = {
'tau_m':20,
'a':0,
'tau_w':30,
'b':60/(10**12),#we increase the current of b when generating an action potential
'u_reset':-55, #when u reaches thau_reset : reset to u_reset
'u_rest':-70, #rest potential
'R':500*(10**9),
'th':-45, 
'th_rh':-50,#excitability threshold
'DeltaT':2, #slope of the exponential or sharpness
'step':65/(10**12)
}

data_adapting = {
'tau_m':20,
'a':0,
'tau_w':100,
'b':5/(10**12), #we increase the current of b when generating an action potential
'u_reset':-55, #when u reaches thau_reset : reset to u_reset
'u_rest':-70, #rest potential
'R':500*(10**9),
'th':-45, 
'th_rh':-50, #excitability threshold
'DeltaT':2, #slope of the exponential or sharpness
'step':65/(10**12)
}

data_bursting = {
'tau_m':5,
'a':-0.5/(10**12),
'tau_w':100,
'b':7/(10**12),#we increase the current of b when generating an action potential
'u_reset':-46, #when u reaches thau_reset : reset to u_reset
'u_rest':-70, #rest potential
'R':500*(10**9),
'th':-45, 
'th_rh':-50, #excitability threshold
'DeltaT':2, #slope of the exponential or sharpness
'step':65/(10**12)
}

def adex (T,dt,I,data):
    """simulates a transmembrane potential for a given constant current"""    
    N=np.floor( T/dt ).astype (int)
    v=np.zeros(N)
    w=np.zeros(N) #adaptation current: models the effects of the presence of certain ion channels
    v[0]= data['u_rest']
    w[0]=0
    for i in range (N-1):
        if v[i] > data ['th']:#if we exceed the threshold
            v[i]=0
            v[i+1]= data ['u_reset']
            w[i+1]=w[i] + data ['b']
        else :# otherwise we solve the EDOs
            v[i+1] = v[i] + (dt/data['tau_m']) * (-v[i] + data['u_rest'] + data['DeltaT'] * np.exp((v[i]-data['th_rh'])/data['DeltaT']) - data['R']*w[i] + data['R']*I[i])
            w[i+1]= w[i]+dt* (data['a']*(v[i] - data['u_rest']) - w[i]) / data ['tau_w']
    return ([v, w])


#==================================================================
# QUESTION 2 gain function

def gain() :
    """computes the gain function of the AdEx model for the tonic case"""
    freq=[] ; amplitude=[]
    a = 0
    dt= 0.01
    T = 300
    N=np.floor(T/dt).astype(int)
    data = data_tonic
    while a < 100:
        a += 1
        b=a/(10**12)
        I = [b*(i*dt>=0) for i in range(N)]
        [v,w]=adex(T,dt,I,data)
        nombre=0
        #PA counter for intensity
        for i in range(N-1):
            if v[i]<-10 and v[i+1]>-10:
                nombre +=1
       #frequency save
        freq.append(nombre/T)
        amplitude.append(b)
    return amplitude,freq

#=====================================================================

#QUESTION 3 amplitude-duration function (tonic case)
def amplitude_duree():
    """calculates the amplitude-duration function (tonic case)"""
    amp = [] ; dur = []
    T = 5
    dt= 0.01
    N=np.floor(T/dt).astype(int)
    for td in range(1,N):
        PA = False
        a = 0
       #as long as we don't have PA, we increase the intensity I
        while PA != True :
            a += 1
            b = a/(10**10)
            I = [b*((i>=10) and (i<=10+td)) for i in range(N)]        
            [v,w] = adex(T, dt, I, data_tonic)
            #we are looking for a PA
            i = 0
            while i < N-1 and PA == False:
                if v[i]<-40 and v[i+1]>-40: 
                    PA = True
                i+=1
#save [td,Id]
        amp.append(b)
        dur.append(td*dt)
    return dur,amp


#=====================================================================

#QUESTION 4

#ADD NOISE

def adex_random (T,dt,I,data,sigma):
    """simule un potentiel transmembranaire pour un courant constant donné
    avec un bruit brownien"""
    N=np.floor(T/dt).astype (int)
    v=np.zeros(N)
    w=np.zeros(N) #adaptation current: models the effects of the presence of certain ion channels
    v[0]= data['u_rest']
    w[0]=0
    for i in range (N-1):
        if v[i]> data ['th']:#if we exceed the threshold
            v[i]=0
            v[i+1]= data ['u_reset']
            w[i+1]=w[i] + data ['b']
        else :# otherwise we solve the EDOs
            I_alea= sigma *np.random.normal (0 , 1)
            I_det= (dt/data['tau_m']) * (-v[i] + data['u_rest'] + data['DeltaT'] * np.exp((v[i]-data['th_rh'])/data['DeltaT']) - data['R']*w[i] + data['R']*I[i])
            v[i+1] = v[i] + I_det + np.sqrt(dt)*I_alea
            w[i+1]=w[i]+dt* (data['a']*(v[i] - data['u_rest']) - w[i]) / data ['tau_w']
    return ([v, w])

#COUNTING THE TIMES FOR TRIGGERING ACTION POTENTIALS
def nuage():
    """calculates action potential firing times with Brownian noise"""    
    declenchement=[]
    essai=[]
    T = 1000
    sigma = 1/5
    dt=0.01
    N=np.floor(T/dt).astype(int)
    data = data_tonic
    essais = 10
    for i in range(essais+1): #So that it makes 10 attempts and not 9
        I = [data['step']*(i*dt>=0) for i in range(N)]
        [v,w]=adex_random(T,dt,I,data,sigma)
        #compteur des PA pour une intensité
        for j in range(N-1):
            if v[j]<-10 and v[j+1]>-10:
                declenchement.append(j*dt)
                essai.append(i)
    
    return declenchement,essai


def main():
    """"creation of the plots"""
    exo=int(input("\n 1-modèle adex \n 2-fonction de gain \n 3-fonction amplitude-durée \n 4-bruit brownien \n 5-nuage de points \n Entrez le numéro de la fonction à lancer : "))
    
    T=300
    dt=0.01
    sigma = 1/5
    
    #EXERCICE 1
    if exo == 1:
        
        f=int(input("\n 1-tonique \n 2-bursting \n 3-adapting \n Entrez le numéro de la fonction à lancer : "))

        #création du courant
        N=np.floor(T/dt).astype(int) #for better accuracy       
        if f == 1 : data = data_tonic ; titre = "ADEX tonique"
        elif f == 2: data = data_bursting ; titre = "ADEX bursting"
        else : data = data_adapting ; titre = "ADEX adapting"
        I=[data['step']*(i*dt>=0) for i in range(N)]      
        
        [v,w]=adex(T,dt,I,data)

        #creation of the plot
        temps = np.linspace(0.0, T, len(v))
        bottom,top = plt.ylim(-70,10)
        plt.plot(temps,v,label='PTM',linewidth=2)
        plt.xlabel("temps (ms)")
        plt.ylabel("PTM (mV)")
        plt.title(titre)
        plt.legend()
    
    #EXERCICE 2
    elif exo == 2:
        
        amplitude,freq=gain()
        
        #creation of the plot
        plt.plot(amplitude,freq, 'o')
        plt.xlabel("Amplitude (V)")
        plt.ylabel("Fréquence de PA (1/ms)")
        plt.title("Fonction de gain dans le cas tonique")
        plt.legend()
    
    #EXERCICE 3
    elif exo==3:
        dur,amp=amplitude_duree()
        plt.plot(dur, amp, 'o')
        plt.xlabel("Temps de stimulation (ms)")
        plt.ylabel("Intensité du courant (V)")
        plt.title("Fonction amplitude-durée dans le cas tonique")
        plt.legend()
    
    #EXERCICE 4 part 1 : creation of a plot
    elif exo==4:
        data = data_tonic
        N=np.floor(T/dt).astype(int)
        I=[data['step']*(i*dt>=0) for i in range(N)]
        [v,w]=adex_random(T,dt,I,data,sigma)
        adex_random (T,dt,I,data,sigma)

        ##creation of the plot to observe the effect of randomness on the graph
        temps = np.linspace(0.0, T, len(v))
        bottom,top = plt.ylim(-70,10)
        plt.plot(temps,v, 'k', label='PTM',linewidth=2)
        plt.xlabel("temps (ms)")
        plt.ylabel("PTM (mV)")
        plt.title("ADEX Random")
        plt.legend()
    
    #EXERCICE 4 part 2 : cloud creation
    elif exo==5:
        essais = 10
        declenchement,essai=nuage()
        bottom,top = plt.ylim(-0.5,essais+1)
        plt.scatter(declenchement, essai, zorder = 2, s = 2, marker = 'o')
        plt.xlabel("temps (ms)")
        plt.ylabel("essais")
        plt.title("Temps des déclenchements")
        plt.legend()

main()
        

        
        
        
        
    
        
