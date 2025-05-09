import 'package:equatable/equatable.dart';
import 'package:ideahub/model/prompt.dart';

sealed class PromptEvent extends Equatable {
  const PromptEvent();

  @override
  List<Object?> get props => [];
}

final class Load extends PromptEvent {
  const Load();
}

final class AddItem extends PromptEvent {
  final Prompt item;

  const AddItem(this.item);

  @override
  List<Object?> get props => [item];
}

final class RemoveItem extends PromptEvent {
  final Prompt item;

  const RemoveItem(this.item);

  @override
  List<Object?> get props => [item];
}

final class ClearError extends PromptEvent {
  const ClearError();
}