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

## Quick Comments on XGBoost Models
Hey Ben, I figured that I would be easiest to keep track of comments on github rather than via email.  

1. The accuracy metrics look pretty good for the models, but did you try using f1 score or something similar - particularly for the local election where the positive labels are severely underweighted.  [SKLearn allows to switch out those scoring functions](http://scikit-learn.org/stable/modules/model_evaluation.html) when doing parameter optimization, so I'd be curious to see if there is any difference in tuning if you use the f1 scoring function as opposed to accuracy.
2. Just as a reference for future convenience, SKLearn has a good function for [train_test_split](http://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html) so you don't have to write them yourself.  
3. How do you find the `best_params` values for these models?  I can see where they are loaded from, but curious where they were trained from.  You might already be doing this, but [SKLearn's GridSearchCV](http://scikit-learn.org/stable/modules/generated/sklearn.model_selection.GridSearchCV.html) is a pretty great module for tuning parameters in a repeatable fashion.  
4. I've been thinking a little bit on how to best organize this code for re-usability and am thinking that [Spotify's Luigi](https://github.com/spotify/luigi) pipeline package would be an ideal way to go about it.  I think that we could encapsulate the training and scoring workflows into separate tasks.  The training task would just need to take a parameter of the target election.  My thinking here is that a couple of the data pulling and wrangling tasks can be easily shared between the training and scoring workflows and in the future we can parameterize those so that we could potentially generate historical training and scoring runs to populate the Voter Score timeline that we had talked about initially.  Would you have any interest in poking around in Luigi to implement something like this (disclosure: I have like "hello world" type of experience with Luigi but know that it is used pretty widely in the data science world).
