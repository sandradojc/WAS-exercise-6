// calendar manager agent

/* Initial beliefs */
//empty belief
upcoming_event(_).

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://was-course.interactions.ics.unisg.ch/wake-up-ontology#CalendarService (was:CalendarService)
td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#CalendarService", "https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/calendar-service.ttl").

/* Initial goals */ 

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agents believes that a WoT TD of a was:CalendarService is located at Url
 * Body: greets the user
*/
@start_plan
+!start : td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#CalendarService", Url) <-
    .print("Hello world");
    makeArtifact("CalendarService", "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [Url], ArtId);
    .print("Calendar created");
    !read_upcoming_event.

@read_upcoming_event_plan
+!read_upcoming_event : true <-
    readProperty("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#ReadUpcomingEvent",  UpcomingEventLst);
    .nth(0,UpcomingEventLst,UpcomingEvent);
    -+upcoming_event(UpcomingEvent);
    .send(personal_assistant, tell, upcoming_event(UpcomingEvent));
    .print("Told personal assistant about event");
    .wait(5000);
    !read_upcoming_event.

@upcoming_event_plan
+upcoming_event(UpcomingEvent) : true <-
    .print("The upcoming event is ", UpcomingEvent);
    .send(personal_assistant, tell, upcoming_event(UpcomingEvent)).
    
@respond_to_proposal_refuse
+cfp(increase_illuminance) : true <-
    .print("Calendar doesnt react to proposal");
    .send(personal_assistant, tell, refusal(no_react_calendar)).


/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }
