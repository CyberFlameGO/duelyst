Logger = require 'app/common/logger.coffee'
Logger.module('SDK').log 'Initializing SDK...'

# SDK Namespace Wrapper
GameSession = require 'app/sdk/gameSession'

SDK = SDK or {}

SDK.Step = require 'app/sdk/step'
SDK.Utils = require 'app/common/utils/utils_game_session'
SDK.GameType = require 'app/sdk/gameType'
SDK.GameFormat = require 'app/sdk/gameFormat'
SDK.GameSetup = require 'app/sdk/gameSetup'
SDK.GameStatus = require 'app/sdk/gameStatus'
SDK.NetworkManager = require 'app/sdk/networkManager'
SDK.Deck = require 'app/sdk/cards/deck'
SDK.Player = require 'app/sdk/player'
SDK.CardType = require 'app/sdk/cards/cardType'
SDK.CardLocation = require 'app/sdk/cards/cardLocation'
SDK.Card = require 'app/sdk/cards/card'
SDK.CardFactory = require 'app/sdk/cards/cardFactory'
SDK.Cards = require 'app/sdk/cards/cardsLookupComplete'
SDK.CardSet = require 'app/sdk/cards/cardSetLookup'
SDK.CardSetFactory = require 'app/sdk/cards/cardSetFactory'
SDK.CardLore = require 'app/sdk/cards/cardLore'
SDK.Factions = require 'app/sdk/cards/factionsLookup'
SDK.FactionFactory = require 'app/sdk/cards/factionFactory'
SDK.RaceFactory = require 'app/sdk/cards/raceFactory'
SDK.Races = require 'app/sdk/cards/racesLookup'
SDK.Rarity = require 'app/sdk/cards/rarityLookup'
SDK.RarityFactory = require 'app/sdk/cards/rarityFactory'
SDK.PlayModes = require 'app/sdk/playModes/playModesLookup'
SDK.PlayModeFactory = require 'app/sdk/playModes/playModeFactory'
SDK.IntentType = require 'app/sdk/intentType'
SDK.FXType = require 'app/sdk/helpers/fxType'
SDK.Entity = require 'app/sdk/entities/entity'
SDK.Unit = require 'app/sdk/entities/unit'
SDK.Tile = require 'app/sdk/entities/tile'
SDK.Artifact = require 'app/sdk/artifacts/artifact'
SDK.Spell = require 'app/sdk/spells/spell'
SDK.SpellFilterType = require 'app/sdk/spells/spellFilterType'
SDK.SpellApplyEntityToBoard = require 'app/sdk/spells/spellApplyEntityToBoard'
SDK.SpellBuffAttributeByOtherAttribute = require 'app/sdk/spells/spellBuffAttributeByOtherAttribute'
SDK.ActionFactory = require 'app/sdk/actions/actionFactory'
SDK.Action = require 'app/sdk/actions/action'
SDK.DamageAction = require 'app/sdk/actions/damageAction'
SDK.DamageAsAttackAction = require 'app/sdk/actions/damageAsAttackAction'
SDK.HurtingDamageAction = require 'app/sdk/actions/hurtingDamageAction'
SDK.AttackAction = require 'app/sdk/actions/attackAction'
SDK.MoveAction = require 'app/sdk/actions/moveAction'
SDK.ApplyCardToBoardAction = require 'app/sdk/actions/applyCardToBoardAction'
SDK.PlayCardAction = require 'app/sdk/actions/playCardAction'
SDK.PlayCardFromHandAction = require 'app/sdk/actions/playCardFromHandAction'
SDK.PlaySignatureCardAction = require 'app/sdk/actions/playSignatureCardAction'
SDK.PlayCardSilentlyAction = require 'app/sdk/actions/playCardSilentlyAction'
SDK.PlayCardAsTransformAction = require 'app/sdk/actions/playCardAsTransformAction'
SDK.HealAction = require 'app/sdk/actions/healAction'
SDK.DieAction = require 'app/sdk/actions/dieAction'
SDK.KillAction = require 'app/sdk/actions/killAction'
SDK.ResignAction = require 'app/sdk/actions/resignAction'
SDK.BonusManaAction = require 'app/sdk/actions/bonusManaAction'
SDK.TeleportAction = require 'app/sdk/actions/teleportAction'
SDK.SwapUnitsAction = require 'app/sdk/actions/swapUnitsAction'
SDK.RemoveAction = require 'app/sdk/actions/removeAction'
SDK.RefreshExhaustionAction = require 'app/sdk/actions/refreshExhaustionAction'
SDK.SwapUnitAllegianceAction = require 'app/sdk/actions/swapUnitAllegianceAction'
SDK.DrawStartingHandAction = require 'app/sdk/actions/drawStartingHandAction'
SDK.EndTurnAction = require 'app/sdk/actions/endTurnAction'
SDK.StartTurnAction = require 'app/sdk/actions/startTurnAction'
SDK.StopBufferingEventsAction = require 'app/sdk/actions/stopBufferingEventsAction'
SDK.EndFollowupAction = require 'app/sdk/actions/endFollowupAction'
SDK.RollbackToSnapshotAction = require 'app/sdk/actions/rollbackToSnapshotAction'
SDK.ReplaceCardFromHandAction = require 'app/sdk/actions/replaceCardFromHandAction'
SDK.RefreshArtifactChargesAction = require 'app/sdk/actions/refreshArtifactChargesAction'
SDK.PutCardInHandAction = require 'app/sdk/actions/putCardInHandAction'
SDK.PutCardInDeckAction = require 'app/sdk/actions/putCardInDeckAction'
SDK.GenerateSignatureCardAction = require 'app/sdk/actions/generateSignatureCardAction'
SDK.ActivateSignatureCardAction = require 'app/sdk/actions/activateSignatureCardAction'
SDK.DrawCardAction = require 'app/sdk/actions/drawCardAction'
SDK.RemoveCardFromHandAction = require 'app/sdk/actions/removeCardFromHandAction'
SDK.ApplyModifierAction = require 'app/sdk/actions/applyModifierAction'
SDK.RemoveModifierAction = require 'app/sdk/actions/removeModifierAction'
SDK.RevealHiddenCardAction = require 'app/sdk/actions/revealHiddenCardAction'
SDK.BurnCardAction = require 'app/sdk/actions/burnCardAction'
SDK.RestoreChargeToAllArtifactsAction = require 'app/sdk/actions/restoreChargeToAllArtifactsAction'
SDK.ModifierFactory = require 'app/sdk/modifiers/modifierFactory'
SDK.Modifier = require 'app/sdk/modifiers/modifier'
SDK.ModifierCollectableBonusMana = require 'app/sdk/modifiers/modifierCollectableBonusMana'
SDK.PlayerModifierManaModifier = require 'app/sdk/playerModifiers/playerModifierManaModifier'
SDK.ModifierSilence = require 'app/sdk/modifiers/modifierSilence'
SDK.ModifierRanged = require 'app/sdk/modifiers/modifierRanged'
SDK.ModifierAirdrop = require 'app/sdk/modifiers/modifierAirdrop'
SDK.ModifierFlying = require 'app/sdk/modifiers/modifierFlying'
SDK.ModifierProvoke = require 'app/sdk/modifiers/modifierProvoke'
SDK.ModifierProvoked = require 'app/sdk/modifiers/modifierProvoked'
SDK.ModifierRangedProvoke = require 'app/sdk/modifiers/modifierRangedProvoke'
SDK.ModifierRangedProvoked = require 'app/sdk/modifiers/modifierRangedProvoked'
SDK.ModifierStunned = require 'app/sdk/modifiers/modifierStunned'
SDK.ModifierStrikeback = require 'app/sdk/modifiers/modifierStrikeback'
SDK.ModifierFirstBlood = require 'app/sdk/modifiers/modifierFirstBlood'
SDK.ModifierBanded = require 'app/sdk/modifiers/modifierBanded'
SDK.ModifierBanding = require 'app/sdk/modifiers/modifierBanding'
SDK.ModifierDeathWatch = require 'app/sdk/modifiers/modifierDeathWatch'
SDK.ModifierDyingWish = require 'app/sdk/modifiers/modifierDyingWish'
SDK.ModifierBanding = require 'app/sdk/modifiers/modifierBanding'
SDK.ModifierInfiltrate = require 'app/sdk/modifiers/modifierInfiltrate'
SDK.ModifierStackingShadows = require 'app/sdk/modifiers/modifierStackingShadows'
SDK.ModifierEphemeral = require 'app/sdk/modifiers/modifierEphemeral'
SDK.ModifierGrow = require 'app/sdk/modifiers/modifierGrow'
SDK.ModifierRebirth = require 'app/sdk/modifiers/modifierRebirth'
SDK.ModifierEgg = require 'app/sdk/modifiers/modifierEgg'
SDK.ModifierBackstab = require 'app/sdk/modifiers/modifierBackstab'
SDK.ModifierDealDamageWatchKillTarget = require 'app/sdk/modifiers/modifierDealDamageWatchKillTarget'
SDK.ModifierFrenzy = require 'app/sdk/modifiers/modifierFrenzy'
SDK.ModifierBlastAttack = require 'app/sdk/modifiers/modifierBlastAttack'
SDK.ModifierSituationalBuffSelf = require 'app/sdk/modifiers/modifierSituationalBuffSelf'
SDK.ModifierOpeningGambit = require 'app/sdk/modifiers/modifierOpeningGambit'
SDK.ModifierTransformed = require 'app/sdk/modifiers/modifierTransformed'
SDK.ModifierWall = require 'app/sdk/modifiers/modifierWall'
SDK.ModifierAirdrop = require 'app/sdk/modifiers/modifierAirdrop'
SDK.ModifierDestroyAtEndOfTurn = require 'app/sdk/modifiers/modifierDestroyAtEndOfTurn'
SDK.ModifierImmune = require 'app/sdk/modifiers/modifierImmune'
SDK.ModifierImmuneToAttacks = require 'app/sdk/modifiers/modifierImmuneToAttacks'
SDK.ModifierImmuneToAttacksByGeneral = require 'app/sdk/modifiers/modifierImmuneToAttacksByGeneral'
SDK.ModifierImmuneToAttacksByRanged = require 'app/sdk/modifiers/modifierImmuneToAttacksByRanged'
SDK.ModifierImmuneToDamage =   require 'app/sdk/modifiers/modifierImmuneToDamage'
SDK.ModifierImmuneToDamageByGeneral = require 'app/sdk/modifiers/modifierImmuneToDamageByGeneral'
SDK.ModifierImmuneToDamageByRanged = require 'app/sdk/modifiers/modifierImmuneToDamageByRanged'
SDK.ModifierImmuneToSpellsByEnemy = require 'app/sdk/modifiers/modifierImmuneToSpellsByEnemy'
SDK.ModifierImmuneToSpells = require 'app/sdk/modifiers/modifierImmuneToSpells'
SDK.ModifierImmuneToDamageBySpells = require 'app/sdk/modifiers/modifierImmuneToDamageBySpells'
SDK.ModifierForcefieldAbsorb = require 'app/sdk/modifiers/modifierForcefieldAbsorb'
SDK.ModifierCannot = require 'app/sdk/modifiers/modifierCannot'
SDK.ModifierCannotAttackGeneral = require 'app/sdk/modifiers/modifierCannotAttackGeneral'
SDK.ModifierCannotStrikeback = require 'app/sdk/modifiers/modifierCannotStrikeback'
SDK.ModifierOverwatch = require 'app/sdk/modifiers/modifierOverwatch'
SDK.ModifierSentinel = require 'app/sdk/modifiers/modifierSentinel'
SDK.ModifierBuilding = require 'app/sdk/modifiers/modifierBuilding'
SDK.GameSessionModifier = require 'app/sdk/gameSessionModifiers/gameSessionModifier'

SDK.FactionProgression = require 'app/sdk/progression/factionProgression'
SDK.RankFactory = require 'app/sdk/rank/rankFactory'
SDK.RankDivisionLookup = require 'app/sdk/rank/rankDivisionLookup'

SDK.QuestFactory = require 'app/sdk/quests/questFactory'

SDK.RibbonFactory = require 'app/sdk/ribbons/ribbonFactory'
SDK.Ribbons = require 'app/sdk/ribbons/ribbonLookup'

SDK.ChallengeFactory = require 'app/sdk/challenges/challengeFactory'
SDK.Challenge = require 'app/sdk/challenges/challenge'
SDK.ChallengeRemote = require 'app/sdk/challenges/challengeRemote'
SDK.ChallengeCategory = require 'app/sdk/challenges/challengeCategory'
SDK.Sandbox = require 'app/sdk/challenges/sandbox'
SDK.SandboxDeveloper = require 'app/sdk/challenges/sandboxDeveloper'

SDK.AchievementsFactory = require 'app/sdk/achievements/achievementsFactory'

SDK.Codex = require 'app/sdk/codex/codex'
SDK.CodexChapters = require 'app/sdk/codex/codexChapterLookup'

SDK.NewPlayerProgressionHelper = require 'app/sdk/progression/newPlayerProgressionHelper'
SDK.NewPlayerProgressionStageEnum = require 'app/sdk/progression/newPlayerProgressionStageEnum'
SDK.NewPlayerProgressionModuleLookup = require('app/sdk/progression/newPlayerProgressionModuleLookup')

SDK.CosmeticsFactory = require 'app/sdk/cosmetics/cosmeticsFactory'
SDK.CosmeticsLookup = require 'app/sdk/cosmetics/cosmeticsLookup'
SDK.CosmeticsTypeLookup = require 'app/sdk/cosmetics/cosmeticsTypeLookup'
SDK.CosmeticsChestTypeLookup = require 'app/sdk/cosmetics/cosmeticsChestTypeLookup'
SDK.EmoteCategory = require 'app/sdk/cosmetics/emoteCategory'

SDK.GameSession = GameSession

module.exports = SDK
