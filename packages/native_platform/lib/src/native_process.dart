import 'dart:io' as io;

import 'linux/linux_process.dart';
import 'process.dart';
import 'win32/win32.dart';

/// Represents a process including its metadata and controls.
///
/// Abstract class bridges types for specific operating systems.
/// Used by [LinuxProcess] and [Win32Process].
abstract class NativeProcess {
  // ignore: unused_element
  NativeProcess._unused(this.pid);

  // Return correct subtype depending on the current operating system.
  factory NativeProcess(int pid) {
    if (io.Platform.isLinux) {
      return LinuxProcess(pid);
    } else {
      return Win32Process(pid);
    }
  }

  /// The Process ID (PID) of the given process.
  final int pid;

  /// Name of the executable, for example 'firefox' or 'firefox-bin'.
  Future<String> get executable;

  /// Status will be one of [ProcessStatus.normal],
  /// [ProcessStatus.suspended] or [ProcessStatus.unknown].
  Future<ProcessStatus> get status;

  /// Toggle the suspend / resume state of the given process.
  ///
  /// Returns true for success or false for failure.
  Future<bool> toggle();

  /// Whether or not a process with the given pid currently exists.
  ///
  /// ActiveWindow uses this to check a saved pid is still around.
  Future<bool> exists();

  Future<bool> suspend();

  Future<bool> resume();
}
