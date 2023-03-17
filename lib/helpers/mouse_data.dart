import 'package:ffi/ffi.dart';
import 'dart:ffi';

typedef SetCursorPosC = Void Function(Int32 x, Int32 y);
typedef SetCursorPosDart = void Function(int x, int y);

typedef GetCursorPosC = Int32 Function(Pointer<Int32> lpPoint);
typedef GetCursorPosDart = int Function(Pointer<Int32> lpPoint);

class MouseData {
  static void setCursorPosition(int x, int y) {
    DynamicLibrary user32 = DynamicLibrary.open('user32.dll');
    final SetCursorPosDart setCursorPos = user32
        .lookup<NativeFunction<SetCursorPosC>>('SetCursorPos')
        .asFunction();

    setCursorPos(x, y); // move mouse to (100, 100)
  }

  static Position getMousePosition() {
    DynamicLibrary user32 = DynamicLibrary.open('user32.dll');
    final GetCursorPosDart getCursorPos = user32
        .lookup<NativeFunction<GetCursorPosC>>('GetCursorPos')
        .asFunction();
    final coordinatesPointer =
        calloc<Int32>(2); // Allocate memory for two Int32 values
    getCursorPos(
        coordinatesPointer); // Call the function with a pointer to the allocated memory
    final x = coordinatesPointer
        .value; // Read the X coordinate from the allocated memory
    final y = coordinatesPointer
        .elementAt(1)
        .value; // Read the Y coordinate from the allocated memory
    calloc.free(coordinatesPointer); // Free the allocated memory
    return Position(x, y);
  }
}

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);
}
