from flask import render_template
from vk_app import app
from flask import request
import os
import pdb
import psycopg2 as pg
import datetime
import pdb

from werkzeug.contrib.cache import SimpleCache

CACHE_TIMEOUT = 300

cache = SimpleCache()

def get_cache(request):
        key = (request.args.get('last').upper(), request.args.get('first'))
        result = cache.get(key)
        if result is None:
            result = retrieve_user(request.args.get('first').upper(),
                         request.args.get('last').upper(),
                         request.args.get('dob') )
            cache.set(key, result, timeout=CACHE_TIMEOUT)
        return result

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
    if (len(str(dob))<8)|(int(str(dob)[0:4]) not in range(1900,2012)):
        return('DOB needs to be formatted: YYYYMMDD')
    
    conn = pg.connect(database=os.environ['VK_DB'], user=os.environ['VK_U'], 
                      password=os.environ['VK_PW'], host=os.environ['VK_HOST'], port=os.environ['VK_PORT'])
    cur = conn.cursor()
    
    pred_sql = '''
                SELECT score_total_scaled, local_general, national_presidential, national_midterm
                FROM voter_grades
                inner join rawvoters
                on (rawvoters.id = voter_grades.rawvoter_id)
                where 
                rawvoters.lastname = '{}'
                AND rawvoters.dob = '{}'
                AND rawvoters.firstname like '{}%'
                '''.format(last, dob, first)
    

    cur.execute(pred_sql)
    pred = cur.fetchall()
    if pred != []:
        pred = [int(x*100) for x in pred[0]]
        return(pred)
    else:
        return("Voter {} not found!".format(' '.join([first, last])))
    
@app.route('/')
def test():
    return render_template('input_frontpage.html')

@app.route('/profile')
def fancy_output():
    
    result = get_cache(request)
    
    # Check if retrieved info
    if isinstance(result, str):
        return render_template('input_frontpage.html', error=result)
    
    return render_template('dashboard.html',
                          over = result[0], over_avg = avg_score[0],
                           local = result[1], local_avg = avg_score[1] ,
                           pres = result[2], pres_avg = avg_score[2],
                           mid = result[3], mid_avg = avg_score[3],
                          name = request.args.get('first'))