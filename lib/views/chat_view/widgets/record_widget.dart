import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/controllers/chat_view_controllers/audio_recording_controller.dart';
import 'package:whats_app/controllers/chat_view_controllers/chat_controller.dart';

class RecordWidget extends StatefulWidget {
  @override
  _RecordWidgetState createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> {
  double width = 400;
  bool isTrashIconVisible = false;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<AudioRecordingController>(
        create: (context) => AudioRecordingController(
          chatController: Provider.of<ChatController>(
            context,
            listen: false,
          ),
        ),
        child: Consumer<AudioRecordingController>(
          builder: (context, controller, child) => Row(
            children: [
              Flexible(
                child: Container(
                  width: width,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (isTrashIconVisible) _buildAnimatedDeleteButton(),
                      controller.currentState.isRecording
                          ? Expanded(child: _CancelSliderWidgetForRecordingButton())
                          : Expanded(child: _MessageInputWidget()),
                      SizedBox(width: 5.0),
                      AudioRecordingButton(
                        onLongPressMoveUpdate: (offset) {
                          updateUIOrStopRecordingBasedOn(offset, controller: controller);
                        },
                        onLongPressUp: () {
                          resetWidth();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildAnimatedDeleteButton() => AnimatedContainer(
        height: isTrashIconVisible ? 40.0 : 0.0,
        width: isTrashIconVisible ? 40.0 : 0.0,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeIn,
        child: Center(
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      );

  void updateUIOrStopRecordingBasedOn(
    Offset dragOffset, {
    AudioRecordingController controller,
  }) {
    final distanceDraggedFromRight = -dragOffset.dx;

    if (distanceDraggedFromRight > 120.0) {
      controller.cancelRecording();
      resetWidth();
      showAndHideTrashIcon();
    } else {
      updateWidthTo(MediaQuery.of(context).size.width - distanceDraggedFromRight);
    }
  }

  void updateWidthTo(double width) {
    setState(() {
      this.width = width;
    });
  }

  void resetWidth() {
    updateWidthTo(double.infinity);
  }

  void showAndHideTrashIcon() async {
    setState(() {
      isTrashIconVisible = true;
    });

    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      isTrashIconVisible = false;
    });
  }
}

class _CancelSliderWidgetForRecordingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<AudioRecordingController>(
        builder: (context, controller, child) => Container(
          height: 40.0,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blueGrey.withAlpha(120),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${controller.currentState.secondsElapsedSinceRecordingStarted.toSecondsAndMinutes}'),
              Row(
                children: [
                  Text(
                    'Slide to cancel',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _MessageInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<AudioRecordingController>(
        builder: (context, controller, child) => Container(
          height: 40.0,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blueGrey.withAlpha(120),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Row(
                children: [
                  VerticalDivider(
                    color: Colors.grey,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      );
}

class AudioRecordingButton extends StatelessWidget {
  static const double disabledRadius = 20.0;
  static const double enabledRadius = 25.0;

  final void Function(Offset offset) onLongPressMoveUpdate;
  final VoidCallback onLongPressUp;

  const AudioRecordingButton({
    Key key,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<AudioRecordingController>(
        builder: (context, controller, child) => Transform.scale(
          scale: controller.currentState.isRecording ? 1.7 : 1.0,
          child: GestureDetector(
            onLongPress: () {
              controller.startRecording();
            },
            onLongPressUp: () {
              controller.stopRecording();
              onLongPressUp?.call();
            },
            onLongPressMoveUpdate: (longPressMoveUpdate) {
              onLongPressMoveUpdate?.call(longPressMoveUpdate.localOffsetFromOrigin);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceOut,
              height: radiusBasedOnCurrentState(controller) * 2,
              width: radiusBasedOnCurrentState(controller) * 2,
              decoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  double radiusBasedOnCurrentState(AudioRecordingController controller) {
    if (controller.currentState.isRecording) {
      return AudioRecordingButton.enabledRadius;
    } else {
      return AudioRecordingButton.disabledRadius;
    }
  }
}

extension on int {
  String get toSecondsAndMinutes {
    final numberOfMinutes = this ~/ 60;
    final numberOfSeconds = this % 60;

    if (numberOfMinutes < 10) {
      if (numberOfSeconds < 10) {
        return '0$numberOfMinutes:0$numberOfSeconds'; //
      } else {
        return '0$numberOfMinutes:$numberOfSeconds'; //
      }
    } else {
      if (numberOfSeconds < 10) {
        return '$numberOfMinutes:0$numberOfSeconds'; //
      } else {
        return '$numberOfMinutes:$numberOfSeconds'; //
      }
    }
  }
}
