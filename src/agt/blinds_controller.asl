// blinds controller agent

/* Initial beliefs */

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds (was:Blinds)
td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds", "https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/blinds.ttl").

// the agent initially believes that the blinds are "lowered"
blinds("lowered").

/* Initial goals */ 

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agents believes that a WoT TD of a was:Blinds is located at Url
 * Body: greets the user
*/
@start_plan
+!start : td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds", Url) <-
    .print("Hello world");
    makeArtifact("Blinds", "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [Url], ArtId);
    .print("Blinds created");
    !read_blinds_state.

@read_blinds_state_plan_when_lowered
+!read_blinds_state : blinds("lowered") <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["raised"]);
    -+blinds("raised");
    .print("Blinds are raised");
    .send(personal_assistant, tell, blinds("raised")).

@read_blinds_state_plan_when_raised
+!read_blinds_state : blinds("raised") <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["lowered"]);
    -+blinds("lowered");
    .print("Blinds are lowered");
    .send(personal_assistant, tell, blinds("lowered")).

@respond_to_proposal_accept
+cfp(increase_illuminance) : blinds("lowered") <-
    .print("Blinds are lowered, sending proposal to raise them");
    .send(personal_assistant, tell, proposal(raise_blinds)).

@respond_to_proposal_refuse
+cfp(increase_illuminance) : blinds("raised") <-
    .print("Blinds are already raised, sending refusal");
    .send(personal_assistant, tell, refusal(raise_blinds)).

@execution_blinds
+execute(raise_blinds) : true <-
    !read_blinds_state.

@blinds_state_plan
+blinds(BlindsState) : true <-
    .print("The blinds state is ", BlindsState).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }