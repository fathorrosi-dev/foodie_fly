part of 'addons_bloc.dart';

abstract class AddonsState extends Equatable {
  const AddonsState();

  @override
  List<Object> get props => [];
}

class AddonsInitial extends AddonsState {}

class AddonsLoading extends AddonsState {}

class AddonsLoaded extends AddonsState {
  final List<AddonEntity> addons;

  const AddonsLoaded(this.addons);

  @override
  List<Object> get props => [addons];
}

class AddonsError extends AddonsState {
  final String message;

  const AddonsError(this.message);

  @override
  List<Object> get props => [message];
}
