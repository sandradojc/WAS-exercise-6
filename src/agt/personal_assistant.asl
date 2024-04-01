// personal assistant agent

// inital rules 
best_option(Rank) :- Rank = 0.

// initial beliefs
natural_light(0).
artifical_light(1).
blinds("lowered").
lights("off").

/* Initial goals */ 

// The agent has the goal to sxtart
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: true (the plan is always applicable)
 * Body: greets the user
*/
@start_plan
+!start : true <-
    .print("Hello world").

@create_dweet_plan
+!createDweet : blinds("raised") & lights("on") <-
    makeArtifact("dweet","room.DweetArtifact", [], DweeterId);
    .print("Dweet created").

@react_to_event_plan_when_awake
+upcoming_event("now") : owner_state("awake") <-
    .print("Enjoy your event!").

@react_to_event_plan_when_eventnow
+upcoming_event("now") : owner_state("asleep") <-
    .print("Starting wake up routine.");
    !wakeup_routine.

@react_to_event_plan_when_asleep
+owner_state("asleep") : upcoming_event("now") <-
    .print("Starting wake up routine.");
    !wakeup_routine.

@wakeup_routine_plan
+!wakeup_routine : true <-
    .print("Starting wakeup routine");
    .broadcast(tell, cfp(increase_illuminance));
    .print("broadcasting started to increase illuminance").

@wakeup_blinds
+proposal(raise_blinds) : blinds("lowered") <-
    .print("Received blinds proposal and executing");
    .send(blinds_controller, tell, execute(raise_blinds)).

@handle_refusal_blinds
+refusal(raise_blinds) : true <-
    .print("Proposal to raise blinds was refused, attempting to turn on lights");
    !wakeup_routine.

@wakeup_lights
+proposal(turn_on_lights) : blinds("raised") & lights("off") <-
    .print("Received lights proposal and executing");
    .send(lights_controller, tell, execute(turn_on_lights)).

@handle_refusal_lights
+refusal(turn_on_lights) : true <-
    .print("Proposal to turn on lights was refused, attempting to dweet");
    !createDweet.

@handle_refusal_calendar
+refusal(no_react_calendar) : true <-
    .print("Calendar saw the broadcast message").

@handle_refusal_wristband
    +refusal(no_react_wristband) : true <-
    .print("Wristband saw the broadcast message").

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }