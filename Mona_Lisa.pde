import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.awt.event.KeyEvent;



static String OAuthConsumerKey = "hJPBcd9DtL1nyhGPIxCAPk0yr";
static String OAuthConsumerSecret = "znKrcaV8iliDCN0I0llMFw5vQy1PESakZVtG5JCL2CVEtAHruy";
static String AccessToken = "235178974-HPBPwGfoP7VPf61Uv2hbkWnIgLwCeV2Rhjx1EcfG";
static String AccessTokenSecret = "e7IFuFx3JUbxCr9WBDrRdO7rmHzJ4PgdLP9PlYWyKa92B";
TwitterStream twitter = new TwitterStreamFactory().getInstance(); 




int width = 1280;
int height = 768;
int y;
int happyFeelingcounter = 0;
int sadFeelingcounter = 0;
int totalCounter=0;


String happyFeeling = ":)";
String sadFeeling =  ":(";
color happyFeelingcolor = color(157,43,45);
color sadFeelingcolor = color(215, 157, 146);

PImage bgimage;
PFont f;
PImage img;

AudioPlayer player;
Minim minim;//audio context


void setup()
{
  
  minim = new Minim(this);
  player = minim.loadFile("music.mp3", 2048);
  player.play();
  player.loop();
  
  
  connectTwitter();
  twitter.addListener(listener);
  
   
   String keywords[] = {happyFeeling, sadFeeling};
   twitter.filter(new FilterQuery().track(keywords));

  size(1280, 768);
  f = createFont("Segoe UI", 14);
  textFont(f);
  //background(color(0,0,0));  //bg color


   //background(0);


  totalCounter=happyFeelingcounter+sadFeelingcounter;

  bgimage = loadImage("bg1.jpg");
  background(bgimage);
}

void draw()
{
 
 
  int s = second();  // Values from 0 - 59
  int m = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  
  //System.out.println("Time-->  " + h + ":" + m + ":" + s);
  
 totalCounter=happyFeelingcounter+sadFeelingcounter;

   
  line(640, 700, 640, 135);
  

  fill(color(100,40,40));
  rect(width*0, height*.1, width*.3, height*.05);
  rect(width*.7, height*.1, width*1, height*.05);
  rect(width*.9, height*.05, width*1, height*.05);
  fill(color(105, 142, 255));
  rect(width*.9, height*.7, width*1, height*.05);
  
  
  fill(color(255,255,255)); 
  text(happyFeeling, width*.05, height*.125);
  text("Counter" +":  "+ happyFeelingcounter, width*.23, height*.125);
  
  
  text(sadFeeling, width*.75, height*.125);
  text("Counter" +":  "+ sadFeelingcounter, width*.93, height*.125);

  text("Total Tweets" +":  "+ totalCounter, width*.905, height*.085);
 
 text("Time  " + h + ":" + m + ":" + s,width*.91, height*.73); 
  
  double percent = (double)happyFeelingcounter / (happyFeelingcounter+sadFeelingcounter);  
  fill(happyFeelingcolor);
  rect(width*0, height*.15, (int)(width*percent), height*.03);
  fill(sadFeelingcolor);
  rect((int)(width*percent), height*.15, width*1, height*.03);
  
  fill(sadFeelingcolor);
  text(Double.toString(round((float)percent*1000)/(int)10)+"%", (int)(percent*width/2.5), (int)height*.17);                //mikos baras posostou height
  fill(happyFeelingcolor);                                                                                                 //
  text(Double.toString(100-round((float)percent*1000)/(int)10)+"%", width-(int)((1-percent)*width/1.9), (int)height*.17);  //
  
  
  
  //background(204);
  
  
 
 
}



// Initial connection
void connectTwitter() {
twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
AccessToken accessToken = loadAccessToken();
twitter.setOAuthAccessToken(accessToken);
}
// Loading up the access token
private static AccessToken loadAccessToken() {
return new AccessToken(AccessToken, AccessTokenSecret);
}

// This listens for new tweet
StatusListener listener = new StatusListener() {
  
  
  public void onStatus(Status status) {
    if (status.getText().indexOf(happyFeeling)!= -1)
    {
      happyFeelingcounter++;
      image(loadImage((status.getUser().getMiniProfileImageURL())), (int)random(width*.45), height-(int)random(height*0.7));
      //text("@"+status.getUser().getName() + " : "+" " + status.getText() ,random(800),random(300));
    }
    if (status.getText().indexOf(sadFeeling)!= -1) 
    {
      sadFeelingcounter++;
      image(loadImage((status.getUser().getMiniProfileImageURL())), width-(int)random(width*.45), height-(int)random(height*0.7));
      //text("@"+status.getUser().getName() + " : "+" "  + status.getText() ,random(800),random(300));
    } 
  }
  public void onStallWarning(StallWarning stallwarning){}
  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {}
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {}
  public void onScrubGeo(long userId, long upToStatusId) {
  System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }
  public void onException(Exception ex) {
    ex.printStackTrace();
  }



};