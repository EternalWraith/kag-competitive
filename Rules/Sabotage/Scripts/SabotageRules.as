#define SERVER_ONLY;

#include "SabotageRulesCore.as";
#include "SabotageRespawnSystem.as";


void onInit(CRules@ this) {
	print("SabotageRules:onInit");
	this.set_u32("startTime", getGameTime());

	return;
}

void onRestart(CRules@ this) {
	print("SabotageRules:onRestart");

	SabotageRespawnSystem respawnSystem();
	SabotageRulesCore rulesCore(this, respawnSystem);

	this.set("core", @rulesCore);

	return;
}
