import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/domain/entities/addon_entity.dart';
import 'package:foodie_fly/domain/usecases/get_addons.dart';

part 'addons_event.dart';
part 'addons_state.dart';

class AddonsBloc extends Bloc<AddonsEvent, AddonsState> {
  final GetAddons _getAddons;

  AddonsBloc(this._getAddons) : super(AddonsInitial()) {
    on<GetAddonsEvent>(_getAddonsEvent);
  }

  Future<void> _getAddonsEvent(
    GetAddonsEvent event,
    Emitter<AddonsState> emit,
  ) async {
    emit(AddonsLoading());
    final result = await _getAddons.execute(event.category);

    result.fold(
      (failure) => emit(AddonsError(failure.message)),
      (addons) => emit(AddonsLoaded(addons)),
    );
  }
}
