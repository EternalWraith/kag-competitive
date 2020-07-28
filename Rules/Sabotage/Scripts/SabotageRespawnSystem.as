#include "RulesCore.as";
#include "RespawnSystem.as";


class SabotageRespawnSystem : RespawnSystem {
  PlayerInfo@[] playerInfoSpawnQueue;

  void SetCore(RulesCore@ rulesCore) override {
    RespawnSystem::SetCore(rulesCore);
  }

  void Update() override {
    PlayerInfo@ playerInfo;

    for (int i = 0; i < playerInfoSpawnQueue.length; i++) {
      @playerInfo = playerInfoSpawnQueue[i];

      DoSpawnPlayer(@playerInfo);
    }

    return;
  }

  void AddPlayerToSpawn(CPlayer@ player) override {
    PlayerInfo@ playerInfo = core.getInfoFromPlayer(player);

    if (playerInfo is null || player.getTeamNum() == core.rules.getSpectatorTeamNum()) {
      return;
    }

    RemovePlayerFromSpawn(player);
    playerInfoSpawnQueue.push_back(playerInfo);

    return;
  }

  void RemovePlayerFromSpawn(CPlayer@ player) override {
    PlayerInfo@ playerInfo = core.getInfoFromPlayer(player);

    if (playerInfo is null) {
      return;
    }

    int playerQueuePosition = playerInfoSpawnQueue.find(playerInfo);

    if (playerQueuePosition != -1) {
      playerInfoSpawnQueue.erase(playerQueuePosition);
    }

    return;
  }

  bool isSpawning(CPlayer@ player) override {
    PlayerInfo@ playerInfo = core.getInfoFromPlayer(player);

    return playerInfoSpawnQueue.find(playerInfo) != -1;
  }

  void DoSpawnPlayer(PlayerInfo@ playerInfo) override {
    BaseTeamInfo teamInfo = core.teams[playerInfo.team];

    RespawnSystem::DoSpawnPlayer(playerInfo);

    return;
  }

}
