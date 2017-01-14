import pdb
import psycopg2 as pg
import pandas as pd
import datetime
from sklearn.linear_model import LogisticRegression


# Utilities
def date_to_years(start, end=datetime.date.today()):
    return (end - start.date()).days / 365

def convert_to_date(col):
    return pd.to_datetime(col, errors='ignore', format="%Y-%m-%d")

# END


conn = pg.connect("dbname=voter_karma user=votemaster")
cur = conn.cursor()

headers = (
'id', 'dob', 'gender', 'status', 'enrollment', 'district', 'regdate', 
'idrequired', 'idmet',
'e2001_09_primary',
'e2001_11_general',
'e2005_09_primary',
'e2005_11_general',
'e2006_11_general',
'e2008_02_primary',
'e2008_11_general',
'e2009_09_primary',
'e2009_11_general',
'e2010_09_primary',
'e2010_11_general',
'e2012_06_primary',
'e2012_09_primary',
'e2012_11_general',
'e2013_09_primary',
'e2013_11_general',
'e2014_06_primary',
'e2014_11_general'
)

sel = """
SELECT {}
FROM {}
LIMIT (%s);
""".format(', '.join(headers), 'raw_voters')

cur.execute(sel, (50,))
df = pd.DataFrame.from_records(cur.fetchall(), columns=headers)

# Set index to 'id' and drop id
df.set_index(['id'], inplace=True)
# Convert Date fields to years duration
df[df.select_dtypes(['object']).columns] = df.select_dtypes(['object']).apply(convert_to_date)
df[df.select_dtypes(['datetime64[ns]']).columns] = \
        df.select_dtypes(['datetime64[ns]']).applymap(lambda x:
                date_to_years(x))
# Create categories and pivot them
df[df.select_dtypes(['object']).columns] = \
        df.select_dtypes(['object']).apply(lambda x: x.astype('category'))


# Pivot categorical variables
cat_cols = df.select_dtypes(['category']).columns
for col in cat_cols:
    dummy = pd.get_dummies(df[col], prefix=col)
    df = pd.concat([df, dummy], axis=1)

df.drop(cat_cols, axis=1, inplace=True)

# Assign Target / create labels and train
target = 'e2013_09_primary'
y = df[target]
X = df.drop([target], axis=1)

mod = LogisticRegression()
mod.fit(X, y)

