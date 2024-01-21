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
'b':60/(10**12), #on augmente le courant de b lors de la génération d'un potentiel d'action
'u_reset':-55, #lorsque u atteint thau_reset : réinitialisé à u_reset
'u_rest':-70, #potentiel de repos
'R':500*(10**9),
'th':-45, 
'th_rh':-50, #seuil d'excitabilité
'DeltaT':2, #pente de l'exponentielle ou sharpness
'step':65/(10**12)
}

data_adapting = {
'tau_m':20,
'a':0,
'tau_w':100,
'b':5/(10**12), #on augmente le courant de b lors de la génération d'un potentiel d'action
'u_reset':-55, #lorsque u atteint thau_reset : réinitialisé à u_reset
'u_rest':-70, #potentiel de repos
'R':500*(10**9),
'th':-45, 
'th_rh':-50, #seuil d'excitabilité
'DeltaT':2, #pente de l'exponentielle ou sharpness
'step':65/(10**12)
}

data_bursting = {
'tau_m':5,
'a':-0.5/(10**12),
'tau_w':100,
'b':7/(10**12), #on augmente le courant de b lors de la génération d'un potentiel d'action
'u_reset':-46, #lorsque u atteint thau_reset : réinitialisé à u_reset
'u_rest':-70, #potentiel de repos
'R':500*(10**9),
'th':-45, 
'th_rh':-50, #seuil d'excitabilité
'DeltaT':2, #pente de l'exponentielle ou sharpness
'step':65/(10**12)
}

def adex (T,dt,I,data):
    """simule un potentiel transmembranaire pour un courant constant donné"""
    N=np.floor( T/dt ).astype (int)
    v=np.zeros(N)
    w=np.zeros(N) #courant d'adaptation : modélise les effets de la présence de certains canaux ioniques
    v[0]= data['u_rest']
    w[0]=0
    for i in range (N-1):
        if v[i] > data ['th']:#si on depasse le seuil
            v[i]=0
            v[i+1]= data ['u_reset']
            w[i+1]=w[i] + data ['b']
        else :# sinon on resout les EDO
            v[i+1] = v[i] + (dt/data['tau_m']) * (-v[i] + data['u_rest'] + data['DeltaT'] * np.exp((v[i]-data['th_rh'])/data['DeltaT']) - data['R']*w[i] + data['R']*I[i])
            w[i+1]= w[i]+dt* (data['a']*(v[i] - data['u_rest']) - w[i]) / data ['tau_w']
    return ([v, w])


#==================================================================

# QUESTION 2 fonction de gain

def gain() :
    """calcule la fonction de gain du modèle AdEx pour le cas tonique"""
    freq=[] ; amplitude = []
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
        #compteur des PA pour une intensité
        for i in range(N-1):
            if v[i]<-10 and v[i+1]>-10:
                nombre +=1
        #sauvegarde de la fréquence
        freq.append(nombre/T)
        amplitude.append(b)
    return amplitude,freq

#=====================================================================

#QUESTION 3 fonction amplitude-durée (cas tonique)
def amplitude_duree():
    """calcule la fonction amplitude-durée (cas tonique)"""
    amp = [] ; dur = []
    T = 5
    dt= 0.01
    N=np.floor(T/dt).astype(int)
    for td in range(1,N):
        PA = False
        a = 0
        #tant qu'on a pas de PA, on augmente l'intensité I
        while PA != True :
            a += 1
            b = a/(10**10)
            I = [b*((i>=10) and (i<=10+td)) for i in range(N)]        
            [v,w] = adex(T, dt, I, data_tonic)
            #on cherche un PA 
            i = 0
            while i < N-1 and PA == False:
                if v[i]<-40 and v[i+1]>-40: 
                    PA = True
                i+=1
        #enregistrer [td,Id]
        amp.append(b)
        dur.append(td*dt)
    return dur,amp


#=====================================================================

#QUESTION 4

#AJOUTER UN BRUIT

def adex_random (T,dt,I,data,sigma):
    """simule un potentiel transmembranaire pour un courant constant donné
    avec un bruit brownien"""
    N=np.floor(T/dt).astype (int)
    v=np.zeros(N)
    w=np.zeros(N) #courant d'adaptation : modélise les effets de la présence de certains canaux ioniques
    v[0]= data['u_rest']
    w[0]=0
    for i in range (N-1):
        if v[i]> data ['th']:#si on depasse le seuil
            v[i]=0
            v[i+1]= data ['u_reset']
            w[i+1]=w[i] + data ['b']
        else :# sinon on resout les EDO
            I_alea= sigma *np.random.normal (0 , 1)
            I_det= (dt/data['tau_m']) * (-v[i] + data['u_rest'] + data['DeltaT'] * np.exp((v[i]-data['th_rh'])/data['DeltaT']) - data['R']*w[i] + data['R']*I[i])
            v[i+1] = v[i] + I_det + np.sqrt(dt)*I_alea
            w[i+1]=w[i]+dt* (data['a']*(v[i] - data['u_rest']) - w[i]) / data ['tau_w']
    return ([v, w])

#COMPTER LES TEMPS DE DECLENCHEMENT DES POTENTIELS D'ACTION
def nuage():
    """calcule les temps de déclenchement des potentiels d'actions avec un bruit brownien"""
    declenchement=[]
    essai=[]
    T = 1000
    sigma = 1/5
    dt=0.01
    N=np.floor(T/dt).astype(int)
    data = data_tonic
    essais = 10
    for i in range(essais+1): #Pour que ça fasse les 10 essais et pas 9 
        I = [data['step']*(i*dt>=0) for i in range(N)]
        [v,w]=adex_random(T,dt,I,data,sigma)
        #compteur des PA pour une intensité
        for j in range(N-1):
            if v[j]<-10 and v[j+1]>-10:
                declenchement.append(j*dt)
                essai.append(i)
    
    return declenchement,essai


def main():
    """"création des plots"""
    exo=int(input("\n 1-modèle adex \n 2-fonction de gain \n 3-fonction amplitude-durée \n 4-bruit brownien \n 5-nuage de points \n Entrez le numéro de la fonction à lancer : "))
    
    T=300
    dt=0.01
    sigma = 1/5
    
    #EXERCICE 1
    if exo == 1:
        
        f=int(input("\n 1-tonique \n 2-bursting \n 3-adapting \n Entrez le numéro de la fonction à lancer : "))

        #création du courant
        N=np.floor(T/dt).astype(int) #pour avoir une meilleure précision
        if f == 1 : data = data_tonic ; titre = "ADEX tonique"
        elif f == 2: data = data_bursting ; titre = "ADEX bursting"
        else : data = data_adapting ; titre = "ADEX adapting"
        I=[data['step']*(i*dt>=0) for i in range(N)]      
        
        [v,w]=adex(T,dt,I,data)

        #création du plot
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
        
        #création du plot
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
    
    #EXERCICE 4 part 1 : création d'un plot
    elif exo==4:
        data = data_tonic
        N=np.floor(T/dt).astype(int)
        I=[data['step']*(i*dt>=0) for i in range(N)]
        [v,w]=adex_random(T,dt,I,data,sigma)
        adex_random (T,dt,I,data,sigma)

        #création du plot pour observer l'effet de l'aléatoire sur le graphe
        temps = np.linspace(0.0, T, len(v))
        bottom,top = plt.ylim(-70,10)
        plt.plot(temps,v, 'k', label='PTM',linewidth=2)
        plt.xlabel("temps (ms)")
        plt.ylabel("PTM (mV)")
        plt.title("ADEX Random")
        plt.legend()
    
    #EXERCICE 4 part 2 : création du nuage
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
        

        
        
        
        
    
        
