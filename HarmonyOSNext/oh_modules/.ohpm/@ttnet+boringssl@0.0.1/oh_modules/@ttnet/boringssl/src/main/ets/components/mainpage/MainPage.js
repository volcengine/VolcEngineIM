if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
import hilog from "@ohos.hilog";
import testNapi from 'libboringssl.so';
export class MainPage extends ViewPU {
    constructor(o, p, q, r = -1, s = undefined, t) {
        super(o, q, r, t);
        if (typeof s === "function") {
            this.paramsGenerator_ = s;
        }
        this.__message = new ObservedPropertySimplePU('Hello World', this, "message");
        this.setInitiallyProvidedValue(p);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(n) {
        if (n.message !== undefined) {
            this.message = n.message;
        }
    }
    updateStateVars(m) {
    }
    purgeVariableDependenciesOnElmtId(l) {
        this.__message.purgeDependencyOnElmtId(l);
    }
    aboutToBeDeleted() {
        this.__message.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    get message() {
        return this.__message.get();
    }
    set message(k) {
        this.__message.set(k);
    }
    initialRender() {
        this.observeComponentCreation2((i, j) => {
            Row.create();
            Row.height('100%');
        }, Row);
        this.observeComponentCreation2((g, h) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((d, e) => {
            Text.create(this.message);
            Text.fontSize(50);
            Text.fontWeight(FontWeight.Bold);
            Text.onClick(() => {
                hilog.info(0x0000, 'testTag', 'Test NAPI 2 + 3 = %{public}d', testNapi.add(2, 3));
            });
        }, Text);
        Text.pop();
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
