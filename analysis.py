from autogluon.tabular import TabularPredictor, TabularDataset
import json

label = "pdl1"
time_limit = 60 * 60 # for quick demonstration only, you should set this to longest time you are willing to wait (in seconds)
metric = 'roc_auc'  # specify your evaluation metric here


scores = {}
for i in range(1,11):
    train_data = TabularDataset(f"/home/data/train/pdl_train_{i}.csv")
    predictor = TabularPredictor(
        label,
        path = f"/home/results/splits/split_{i}",
        eval_metric=metric,
    ).fit(
        train_data,
        num_cpus=4,
        time_limit=time_limit,
        presets="best_quality"
    )
    test_data = TabularDataset(f"/home/data/test/test_{i}.csv")
    scores[i] = predictor.evaluate(test_data)

json.dump(scores, open("/home/results/scores.json", "w"))