// lights controller agent

/* Initial beliefs */

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights (was:Lights)
td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights", "https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/lights.ttl").

// The agent initially believes that the lights are "off"
lights("off").

/* Initial goals */ 

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agents believes that a WoT TD of a was:Lights is located at Url
 * Body: greets the user
*/
@start_plan
+!start : td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights", Url) <-
    .print("Hello world");
    makeArtifact("Lights", "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [Url], ArtId);
    .print("Lights created").

@read_lights_state_plan_when_off
+!read_lights_state : lights("off") <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["on"]);
    -+lights("on");
    .print("Lights are on");
    .send(personal_assistant, tell, lights("on")).

@read_lights_state_plan_when_on
+!read_lights_state : lights("on") <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["off"]);
    -+lights("off");
    .print("Lights are off");
    .send(personal_assistant, tell, lights("off")).

@respond_to_proposal_accept
+cfp(increase_illuminance) : lights("off") <-
    .print("Lights are off, sending proposal to turn them on");
    .send(personal_assistant, tell, proposal(turn_on_lights)).

@respond_to_proposal_refuse
+cfp(increase_illuminance) : lights("on") <-
    .print("Lights are already on, sending refusal");
    .send(personal_assistant, tell, refusal(turn_on_lights)).

@execution_lights
+execute(turn_on_lights) : true <-
    !read_lights_state.

@lights_state_plan
+lights(LightsState) : true <-
    .print("The lights state is ", LightsState).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }