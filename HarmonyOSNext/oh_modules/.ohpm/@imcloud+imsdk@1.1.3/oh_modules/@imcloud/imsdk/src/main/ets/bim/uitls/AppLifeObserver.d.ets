import AbilityLifecycleCallback from "@ohos.app.ability.AbilityLifecycleCallback";
import UIAbility from "@ohos.app.ability.UIAbility";
import window from "@ohos.window";
export declare class AppLifeObserver extends AbilityLifecycleCallback {
    private isBackGround;
    private listener;
    onAbilityCreate(ability: UIAbility): void;
    onWindowStageCreate(ability: UIAbility, windowStage: window.WindowStage): void;
    onWindowStageActive(ability: UIAbility, windowStage: window.WindowStage): void;
    onWindowStageInactive(ability: UIAbility, windowStage: window.WindowStage): void;
    onWindowStageDestroy(ability: UIAbility, windowStage: window.WindowStage): void;
    onAbilityDestroy(ability: UIAbility): void;
    onAbilityForeground(ability: UIAbility): void;
    onAbilityBackground(ability: UIAbility): void;
    onAbilityContinue(ability: UIAbility): void;
    constructor(context: Context);
    setChangeListener(l: OnChangeListener): void;
}
interface OnChangeListener {
    onBackground: (ability: UIAbility) => void;
    onForeground: (ability: UIAbility) => void;
}
export {};
