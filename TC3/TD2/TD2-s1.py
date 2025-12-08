# -*- coding: utf-8 -*-
"""
CORRIGE du TD2-s1.py

@author: Ecole Centrale de Lyon, 2025
"""

import http.server
import socketserver

httpd = socketserver.TCPServer(("", 8080),http.server.SimpleHTTPRequestHandler)

httpd.serve_forever()
