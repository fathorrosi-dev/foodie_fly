part of 'addons_bloc.dart';

abstract class AddonsEvent extends Equatable {
  const AddonsEvent();

  @override
  List<Object> get props => [];
}

class GetAddonsEvent extends AddonsEvent {
  final String category;

  const GetAddonsEvent(this.category);

  @override
  List<Object> get props => [category];
}
