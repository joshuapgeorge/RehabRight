# RehabRight — Stroke Rehabilitation Assistant

RehabRight is an AI-powered rehabilitation assistant for stroke survivors doing home-based hand and wrist therapy. Using a smartphone camera and computer vision, it automatically detects whether a patient is correctly performing a hand exercise — closing a fist, opening a palm, or a semi-closed position — and gives instant visual and audio feedback.

Built as part of a UCL Biomedical Engineering Scenario Week (2026), scored 82%.

## Why
Stroke recovery relies heavily on repetitive hand exercises performed consistently over long periods. Many stroke survivors struggle with motivation, isolation, and the lack of a physiotherapist available to give immediate feedback at home. RehabRight aims to close that gap using just a smartphone — no extra hardware required.

## What it does
- Classifies live hand gestures (**Fist**, **Palm**, **Semi-Closed Fist**) from a phone camera feed at ~4fps
- Tracks exercise reps automatically via a Palm → Fist state machine
- Gives instant positive feedback ("Good Job") on correct reps, and withholds feedback to prompt correction on incorrect ones
- Runs entirely on a standard smartphone camera via MATLAB Mobile — no additional hardware

## How it works
- **Model**: GoogLeNet (transfer learning), fine-tuned by replacing the final classification layers for the 3 gesture classes
- **Data**: Custom-collected labelled image dataset across varied hand orientations and lighting conditions
- **Training**: Iterative training with MATLAB's Deep Network Designer; retrained on new data until validation accuracy consistently exceeded our 90% target across 3 runs — final average accuracy ~97%
- **Live inference**: Phone camera frames streamed via MATLAB Mobile, classified in real time, with rep-counting and feedback logic layered on top
- **Interface**: MATLAB App Designer front end for capture, live monitoring, and session performance metrics

## Files
| File | Purpose |
|---|---|
| `Rehabrighttraining1.m` | Trains the model from GoogLeNet (or continues training an existing saved model) |
| `Rehabrighttraining2.m` | Validates the trained model and generates a confusion chart |
| `Rehabrightlivetest.m` | Runs live gesture classification and rep-counting from a phone camera feed |
| `myNet.mat` | Saved trained network |
| `RehabRightFinal.mlapp` | MATLAB App Designer application (full UI) |

## Team
Built with Eli, Alexia, and Abdel as part of a UCL Scenario Week. I led the AI/model development — dataset iteration, training, and validation.

## Validation results
- Target: ≥90% classification accuracy across realistic test conditions (varied hand position, lighting, shadows)
- Achieved: ~97% average validation accuracy across training runs
