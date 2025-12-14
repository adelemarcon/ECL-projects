# -*- coding: utf-8 -*-
"""
Afficher les courbes de résularité des TER pour 6 régions

Correspond au corrigé de la question B.1 de l'annexe du TD1

@author: Ecole Centrale de Lyon, 2025
"""

import datetime as dt
import os
import sqlite3
import matplotlib.pyplot as plt
import matplotlib.dates as pltd

# ouverture d'une connexion avec la base de données après vérification de sa présence
if not os.path.exists('ter.sqlite'):
    raise FileNotFoundError("BD ter.sqlite non trouvée !")
conn = sqlite3.connect('ter.sqlite')

c = conn.cursor()

# Definition des régions et des couleurs de tracé
regions = [("Rhône Alpes","blue"), ("Auvergne","green"), ("Auvergne-Rhône-Alpes","cyan"), ('Bourgogne',"red"), 
           ('Franche Comté','orange'), ('Bourgogne-Franche-Comté','olive') ]

# configuration du tracé
plt.figure(figsize=(18,6))
plt.ylim(80,100)
plt.grid(which='major', color='#888888', linestyle='-')
plt.grid(which='minor',axis='x', color='#888888', linestyle=':')

ax = plt.subplot(111)
ax.xaxis.set_major_locator(pltd.YearLocator())
ax.xaxis.set_minor_locator(pltd.MonthLocator())
ax.xaxis.set_major_formatter(pltd.DateFormatter('%B %Y'))
ax.xaxis.set_tick_params(labelsize=10)

# boucle sur les régions
for reg in (regions) :
    c.execute("SELECT Date,`Tauxderégularité` FROM 'regularite-mensuelle-ter' WHERE Région=? ORDER BY Date",(reg[0],))  
    r = c.fetchall()
    # recupération de la date (1ère colonne) et transformation dans le format date de Python
    x = [dt.date(int(a[0][:4]),int(a[0][5:]),1) for a in r if not (a[1] == '' or a[1] == None)]
    # récupération de la régularité (2e colonne)
    y = [float(a[1]) for a in r if not (a[1] == '' or a[1] == None)]
    # tracé de la courbe
    plt.plot(x,y,linewidth=1, linestyle='-', color=reg[1], label=reg[0])
    
# légendes
plt.legend(loc='lower right')
plt.title('Régularité des TER (en %)',fontsize=16)
plt.ylabel('% de régularité')
plt.xlabel('Date')

# affichage des courbes
plt.show()

# fermeture de la base de données
conn.close()
