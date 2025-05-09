import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ideahub/bloc/prompt_event.dart';
import 'package:ideahub/bloc/prompt_state.dart';
import 'package:ideahub/model/prompt_info.dart';
import 'package:ideahub/repository/prompt_repository.dart';
import 'package:ideahub/util/delayed_result.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  final PromptRepository _promptRepository;

  PromptBloc({
    required PromptRepository promptRepository,
  })  : _promptRepository = promptRepository,
        super(
          const PromptState(
            items: {},
            page: 0,
            loadingResult: DelayedResult.idle()
          ),
        ) {
    on<Load>(_onLoad);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<ClearError>(_onClearError);
  }

  Future<void> _onLoad(Load event, Emitter emit) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      final promptInfo = await _promptRepository.promptInfoFuture;

      emit(
        state.copyWith(
          items: promptInfo.items,
          page: promptInfo.page,
          selectedPrompt: promptInfo.selectedPrompt,
          runningUser: promptInfo.runningUser,
        ),
      );
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
      await emit.onEach(
        _promptRepository.promptInfoStream,
        onData: (PromptInfo promptInfo) {
          emit(
            state.copyWith(
            items: promptInfo.items,
            page: promptInfo.page,
            selectedPrompt: promptInfo.selectedPrompt,
            runningUser: promptInfo.runningUser,
          ),
          );
        },
        onError: (Object error, StackTrace stackTrace) {
          if (kDebugMode) {
            print('Error: $error');
          }
        },
      );
    } on Exception catch (ex) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }

  Future<void> _onAddItem(AddItem event, Emitter emit) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      await _promptRepository.postPrompt(event.item);
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (ex) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }

  Future<void> _onRemoveItem(RemoveItem event, Emitter emit) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      await _promptRepository.removePrompt(event.item.id);
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (ex) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }

  void _onClearError(ClearError event, Emitter emit) {
    emit(state.copyWith(loadingResult: const DelayedResult.idle()));
  }
}