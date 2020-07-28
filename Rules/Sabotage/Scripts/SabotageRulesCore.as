#include "RulesCore.as";
#include "SabotageRespawnSystem";

class SabotageRulesCore : RulesCore {

  int startTime;
  int currentTime;

  int redBomb;
  bool redPlanted;

  int blueBomb;
  bool bluePlanted;

  SabotageRespawnSystem@ respawnSystem;

  SabotageRulesCore() {
    super();
  }

  SabotageRulesCore(CRules@ rules, RespawnSystem@ respawnSystem) {
    super(rules, respawnSystem);
  }

  void Setup(CRules@ rules = null, RespawnSystem@ respawnSystem = null) override {
    RulesCore::Setup(rules, respawnSystem);

    @respawnSystem = cast<SabotageRespawnSystem@>(respawnSystem);

    startTime = getGameTime();


    rules.SetCurrentState(WARMUP);

    redBomb = 30 * getTicksASecond();
    blueBomb = 30 * getTicksASecond();

  }


  void Update() override {
    if (rules.isGameOver()) {
      return;
    }

    currentTime = getGameTime();

    u8 currentGameState = rules.getCurrentState();

    if (rules.isWarmup()) {
      if (allTeamsHaveEnoughPlayers()) {
        rules.SetCurrentState(GAME);

        rules.SetGlobalMessage("");

      } else {
        rules.SetGlobalMessage("Waiting for more players...");
      }
    } else if (currentGameState == GAME) {
      if (redBomb <= 0) {
        if (redPlanted) {
          rules.SetTeamWon(0);
          rules.SetCurrentState(GAME_OVER);
        }
      } else if (blueBomb <= 0) {
        if (bluePlanted) {
          rules.SetTeamWon(1);
          rules.SetCurrentState(GAME_OVER);
        }
      }
    }

    RulesCore::Update();
  }

  bool allTeamsHaveEnoughPlayers() {
    s8 playerCountPerTeam = 3;

    for (uint i = 0; i < teams.length; i++) {
      if (teams[i].players_count < playerCountPerTeam) {
        return false;
      }
    }

    return true;
  }
}
