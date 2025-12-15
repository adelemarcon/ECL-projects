# -*- coding: utf-8 -*-
"""
TD2-corrige-5-3.py : correspond au corrigé du TD2, §5.3 (TD2-s6.py)

@author: Ecole Centrale de Lyon, 2025
"""

import http.server
import socketserver
from urllib.parse import urlparse, parse_qs, unquote
import json

import os
import sqlite3

import datetime as dt
import matplotlib.pyplot as plt
import matplotlib.dates as pltd

# numéro du port TCP utilisé par le serveur
port_serveur = 8080
# nom de la base de données
BD_name = "ter.sqlite"

class RequestHandler(http.server.SimpleHTTPRequestHandler):
  """"Classe dérivée pour traiter les requêtes entrantes du serveur"""

  # sous-répertoire racine des documents statiques
  static_dir = 'client'
  
  def __init__(self, *args, **kwargs):
    """Surcharge du constructeur pour imposer 'client' comme sous répertoire racine"""

    super().__init__(*args, directory=self.static_dir, **kwargs)
    

  def do_GET(self):
    """Traiter les requêtes GET (surcharge la méthode héritée)"""

    # On récupère les étapes du chemin d'accès
    self.init_params()

    # le chemin d'accès commence par /time
    if self.path_info[0] == 'time':
      self.send_time()
   
     # le chemin d'accès commence par /regions
    elif self.path_info[0] == 'regions':
      self.send_regions()
      
    # le chemin d'accès commence par /ponctualite
    elif self.path_info[0] == 'ponctualite':
      self.send_ponctualite()
      
    # ou pas...
    else:
      super().do_GET()


  def send_time(self):
    """Génèrer une réponse avec la date et l'heure du serveur"""
    # on récupère l'heure
    time = self.date_time_string()

    # on génère un document au format html
    body = '<!doctype html>' + \
           '<meta charset="utf-8">' + \
           '<title>L\'heure</title>' + \
           '<div>Voici l\'heure du serveur :</div>' + \
           f'<pre>{time}</pre>'
           
    # pour prévenir qu'il s'agit d'une ressource au format html
    headers = [('Content-Type','text/html;charset=utf-8')]

    # on envoie
    self.send(body,headers)


  def send_regions(self):
    """Génèrer une réponse avec la liste des régions (cf. TD1)"""
 
    # création du curseur (la connexion a été créée par le programme principal)
    c = conn.cursor()
    
    c.execute("SELECT DISTINCT Région FROM 'regularite-mensuelle-ter'")
    r = c.fetchall()
    txt = f'Liste des {len(r)} régions :\n'
    for a in r:
       txt = txt + f'{a[0]}\n'
    
    headers = [('Content-Type','text/plain;charset=utf-8')]
    self.send(txt,headers)
    

  def send_ponctualite(self):
    """Générer un graphique de ponctualite (cf. TD1) et une réponse HTML avec balise IMG"""

    # création du curseur (la connexion a été créée par le programme principal)
    c = conn.cursor()

    # si pas de paramètre => erreur pas de région
    if len(self.path_info) <= 1 or self.path_info[1] == '' :
        print ('Erreur pas de nom')
        self.send_error(400,'Nom de région manquant')  # Région non spécifiée -> erreur 404
        return None
    else:
        # on récupère le nom de la région dans le 1er paramètre
        region = self.path_info[1]
        # On teste que la région demandée existe bien
        c.execute("SELECT DISTINCT Région FROM 'regularite-mensuelle-ter'")
        r = c.fetchall()
        
        # Remarque : r est une liste de tuples à 1 seul élement
        if (region,) not in r:
            # Région non trouvée -> erreur 404
            print ('Erreur nom')
            self.send_error(404,f'{region} : nom de région inconnu')    
            return None
        
    # configuration du tracé
    plt.figure(figsize=(18,6))
    plt.ylim(80,100)
    plt.grid(which='major', color='#888888', linestyle='-')
    plt.grid(which='minor',axis='x', color='#888888', linestyle=':')
    
    ax = plt.subplot(111)
    loc_major = pltd.YearLocator()
    loc_minor = pltd.MonthLocator()
    ax.xaxis.set_major_locator(loc_major)
    ax.xaxis.set_minor_locator(loc_minor)
    format_major = pltd.DateFormatter('%B %Y')
    ax.xaxis.set_major_formatter(format_major)
    ax.xaxis.set_tick_params(labelsize=10)
    
    # interrogation de la base de données pour les données de la région
    c.execute("SELECT Date,`Tauxderégularité` FROM 'regularite-mensuelle-ter' WHERE Région=? ORDER BY Date", (region,))
    r = c.fetchall()
    
    # axe des abscisses : recupération de la date et transformation en date au format python
    x = [dt.date(int(d[:4]),int(d[5:]),1) for (d,t) in r if not (t == '' or t == None)]
    # axe des ordonnées : récupération du taux de régularité
    y = [float(t) for (d,t) in r if not (t == '' or  t==None)]

    # tracé de la courbe
    plt.plot(x,y,linewidth=1, linestyle='-', color='blue', label=region)      
    
    # légendes
    plt.legend(loc='lower right')
    plt.title(f'Régularité des TER (en %) pour la Région {region}',fontsize=16)
    plt.ylabel('% de régularité')
    plt.xlabel('Date')
    
    # génération de la courbe dans un fichier PNG paramétré par le nom de la région
    fichier = f'courbes/ponctualite_{region}.png'
    plt.savefig(f'client/{fichier}')

    body = f'<img src="/{fichier}?{self.date_time_string()}" alt="ponctualite {region}" width="100%">'

    # envoi de la réponse
    headers = [('Content-Type','text/html;charset=utf-8')]
    self.send(body,headers)

    
  def send(self, body, headers=[]):
    """Envoyer la réponse au client avec le corps et les en-têtes fournis
    
    Arguments:
    body: corps de la réponse
    headers: liste de tuples d'en-têtes Cf. HTTP (par défaut : liste vide)
    """
    # on encode la chaine de caractères à envoyer
    encoded = bytes(body, 'UTF-8')

    # on envoie la ligne de statut
    self.send_response(200)

    # on envoie les lignes d'entête et la ligne vide
    [self.send_header(*t) for t in headers]
    self.send_header('Content-Length', int(len(encoded)))
    self.end_headers()

    # on envoie le corps de la réponse
    self.wfile.write(encoded)


  def init_params(self):
    """Analyse la requête pour initialiser nos paramètres"""

    # analyse de l'adresse
    info = urlparse(self.path)
    self.path_info = [unquote(v) for v in info.path.split('/')[1:]]
    self.query_string = info.query
    
    # récupération des paramètres dans la query string
    self.params = parse_qs(info.query)

    # récupération du corps et des paramètres (2 encodages traités)
    length = self.headers.get('Content-Length')
    ctype = self.headers.get('Content-Type')
    if length:
      self.body = str(self.rfile.read(int(length)),'utf-8')
      if ctype == 'application/x-www-form-urlencoded' : 
        self.params = parse_qs(self.body)
      elif ctype == 'application/json' :
        self.params = json.loads(self.body)
    else:
      self.body = ''
   
    # traces
    print('info_path =',self.path_info)
    print('body =',length,ctype,self.body)
    print('params =', self.params)


# Programme principal
if __name__ == '__main__' :
    # ouverture d'une connexion avec la base de données après vérification de sa présence
    if not os.path.exists('ter.sqlite'):
        raise FileNotFoundError("BD ter.sqlite non trouvée !")
    conn = sqlite3.connect('ter.sqlite')
        
    # instanciation et lancement du serveur
    httpd = socketserver.TCPServer(("", port_serveur), RequestHandler)
    httpd.serve_forever()
