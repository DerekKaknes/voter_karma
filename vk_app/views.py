from flask import render_template
from vk_app import app
from flask import request
import os
import pdb
import psycopg2 as pg
import pandas as pd
import numpy as np
import datetime
import pdb
from sklearn.linear_model import LogisticRegression

# Get avg scores
conn = pg.connect(database=os.environ['VK_DB'], user=os.environ['VK_U'], 
                      password=os.environ['VK_PW'], host=os.environ['VK_HOST'], port=os.environ['VK_PORT'])
cur = conn.cursor()
avg_sql = """
            SELECT AVG(score_total_scaled), AVG(local_general), AVG(national_presidential), AVG(national_midterm) 
            from voter_grades
          """
cur.execute(avg_sql)
avg_score = cur.fetchall()[0]
avg_score = [int(x*100) for x in avg_score]

# Utility functions
def retrieve_user(first, last, dob):
    conn = pg.connect(database=os.environ['VK_DB'], user=os.environ['VK_U'], 
                      password=os.environ['VK_PW'], host=os.environ['VK_HOST'], port=os.environ['VK_PORT'])
    cur = conn.cursor()
    pred_sql = '''
                SELECT score_total_scaled, local_general, national_presidential, national_midterm
                FROM voter_grades
                inner join rawvoter
                on (rawvoter.id = voter_grades.raw_voter_id)
                where 
                rawvoter.firstname = '{}'
                AND rawvoter.lastname = '{}'
                '''.format(first, last)

    cur.execute(pred_sql)
    pred = cur.fetchall()[0]
    pred = [int(x*100) for x in pred]
    print pred
    return(pred)

@app.route('/')
def test():
    return render_template('input_frontpage.html')

@app.route('/profile')
def fancy_output():

    if request.args.get('first') == 'Frederick':
        pred = retrieve_user('FREDERICK', 'WILSON', 0)
        return render_template('dashboard.html',
                          over = pred[0], over_avg = avg_score[0],
                           local = pred[1], local_avg = avg_score[1] ,
                           pres = pred[2], pres_avg = avg_score[2],
                           mid = pred[3], mid_avg = avg_score[3])
        
    if request.args.get('first') == 'Sreenath':
        pred = retrieve_user('SREENATH','SREENIVASAN', 1)
        print pred
        return render_template('dashboard.html',
                          over = pred[0], over_avg = avg_score[0],
                           local = pred[1], local_avg = avg_score[1] ,
                           pres = pred[2], pres_avg = avg_score[2],
                           mid = pred[3], mid_avg = avg_score[3])
    
    pred = retrieve_user(request.args.get('first').upper(),
                         request.args.get('last').upper(),
                         request.args.get('dob').upper() )
    
    if pred is None:
        return render_template('test.html', error="No results found for {}, try searching something else".format(request.args.get('first')))
    
    return render_template('dashboard.html',
                          over = pred[0], over_avg = avg_score[0],
                           local = pred[1], local_avg = avg_score[1] ,
                           pres = pred[2], pres_avg = avg_score[2],
                           mid = pred[3], mid_avg = avg_score[3])