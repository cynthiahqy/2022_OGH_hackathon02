OpenGeoHub Hackathon #2

ML Task:
- Predict log transformations of:
  - [ ] Pb concentration (`pb_ppm`);
  - [ ] Zinc concentration (`zn_ppm`);
  - [ ] Total soil carbon in pct (`c_org_pct`);


Inbox:

From spatial extrapolation session
```r
prediction <- predict(predictors,model_random)
truediff <- abs(prediction-response)
plot(stack(prediction,truediff),main=c("prediction","true absolute error"))

### calculate the true map accuracy (in terms of RMSE and R²)
rmse <- function(pred,obs){sqrt( mean((pred - obs)^2, na.rm = TRUE) )}
rmse(values(response),values(prediction))
```
