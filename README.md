# VoterKarma App
## v 0.1

This repo contains the all the resources for the [VoterKarma app](http://voterkarma.herokuapp.com/) on Heroku.  Built using the [Flask](http://flask.pocoo.org/) microframework and Bootstrap style templates.

## Data
Data comes from the NYC voterfile and is hosted on Amazon RDS.  An [API](https://github.com/DerekKaknes/nycvoterfile) is currently under development.

## Scoring
### Model
v.01 models use Logistic Regression for predicting probability of voting in Local, Midterm and National elections.  The model is trained on binary indicators for voting history (i.e. voted/did not vote) from 2001 to 2014.

### VoterKarma Score
v.01 score is the sum of the predicted probability of voting for each of the three models scaled by the maximum value of the summed score.