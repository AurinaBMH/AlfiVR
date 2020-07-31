cd '/Volumes/GoogleDrive/My Drive/Documents/data/Erin'
fname = '6209beac2da84114867b6fabb18e4863-02.analytics';
val = jsondecode(fileread(fname));

%Start of the trial (i.e. Indicator onset)
a = val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Fireball_Onset_Time

%But it is very annoying that all of this is recorded as timestamps. Need a
%fancy matlab function to convert from timestamp strings into numbers

%ReleaseTime - Fireball_Onset_Time = the response. We need this for the
%left and right controllers
val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Controller_Analytics.LeftHand.Inputs.PressTimeTime
b = val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Controller_Analytics.LeftHand.Inputs.ReleaseTimeTime

val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Controller_Analytics.RightHand.Inputs.PressTimeTime
c = val.GameAnalytics.DragonSST.Blocks(3).Trials(3).Controller_Analytics.RightHand.Inputs.ReleaseTimeTime

%THIS IS WHAT WE NEED FOR EACH TRIAL, could insert as new columns in val.GameAnalytics.DragonSST.Blocks(i).Trials(i)
responseTimeLeft = b - a;
responseTimeRight = c - a;

%Then there is all the stop trial information: See here
val.GameAnalytics.DragonSST.Blocks(3).Trials(2).Controller_Analytics.LeftHand
val.GameAnalytics.DragonSST.Blocks(3).Trials(2).Controller_Analytics.LeftHand.StopResponse
