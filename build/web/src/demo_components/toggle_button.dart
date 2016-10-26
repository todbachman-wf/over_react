part of over_react.web.demo_components;

/// Use [ToggleButton]s in order to render functional `<input type="checkbox">` or `<input type="radio">`
/// elements that look like a [Button].
///
/// See: <http://v4-alpha.getbootstrap.com/components/buttons/#checkbox-and-radio-buttons>
@Factory()
UiFactory<ToggleButtonProps> ToggleButton = ([Map backingProps]) => new _$ToggleButtonPropsImpl(backingProps);

@Props()
class ToggleButtonProps extends ButtonProps with AbstractInputPropsMixin {    /* GENERATED CONSTANTS */ static const ConsumedProps $consumedProps = const ConsumedProps($props, $propKeys); static const PropDescriptor _$prop__autoFocus = const PropDescriptor(_$key__autoFocus), _$prop__defaultChecked = const PropDescriptor(_$key__defaultChecked), _$prop__checked = const PropDescriptor(_$key__checked); static const List<PropDescriptor> $props = const [_$prop__autoFocus, _$prop__defaultChecked, _$prop__checked]; static const String _$key__autoFocus = 'autoFocus', _$key__defaultChecked = 'defaultChecked', _$key__checked = 'checked'; static const List<String> $propKeys = const [_$key__autoFocus, _$key__defaultChecked, _$key__checked]; 
  /// Whether the `<input>` rendered by the [ToggleButton] should have focus upon mounting.
  ///
  /// _Proxies [DomProps.autoFocus]._
  ///
  /// Default: `false`
  @Accessor(keyNamespace: '')
  bool get autoFocus => props[_$key__autoFocus];  set autoFocus(bool value) => props[_$key__autoFocus] = value;

  /// Whether the [ToggleButton] is checked by default.
  ///
  /// Setting this without the setting the [checked] prop to will make the [ToggleButton] _uncontrolled_; it will
  /// initially render checked or unchecked depending on the value of this prop, and then update itself
  /// automatically in response to user input, like a normal HTML input.
  ///
  /// _Proxies [DomProps.defaultChecked]._
  ///
  /// See: <https://facebook.github.io/react/docs/forms.html#uncontrolled-components>.
  @Accessor(keyNamespace: '')
  bool get defaultChecked => props[_$key__defaultChecked];  set defaultChecked(bool value) => props[_$key__defaultChecked] = value;

  /// Whether the [ToggleButton] is checked.
  ///
  /// Setting this will make the [ToggleButton] _controlled_; it will not update automatically in
  /// response to user input, but instead will always render checked or unchecked depending on
  /// the value of this prop.
  ///
  /// _Proxies [DomProps.checked]._
  ///
  /// See: <https://facebook.github.io/react/docs/forms.html#controlled-components>.
  @Accessor(keyNamespace: '')
  bool get checked => props[_$key__checked];  set checked(bool value) => props[_$key__checked] = value;
}

@State()
class ToggleButtonState extends UiState with AbstractInputStateMixin {    /* GENERATED CONSTANTS */ static const StateDescriptor _$prop__isFocused = const StateDescriptor(_$key__isFocused), _$prop__isChecked = const StateDescriptor(_$key__isChecked); static const List<StateDescriptor> $state = const [_$prop__isFocused, _$prop__isChecked]; static const String _$key__isFocused = 'ToggleButtonState.isFocused', _$key__isChecked = 'ToggleButtonState.isChecked'; static const List<String> $stateKeys = const [_$key__isFocused, _$key__isChecked]; 
  /// Tracks if the [ToggleButton] is focused. Determines whether to render with the `js-focus` CSS
  /// class.
  ///
  /// Initial: [ToggleButtonProps.autoFocus]
  bool get isFocused => state[_$key__isFocused];  set isFocused(bool value) => state[_$key__isFocused] = value;

  /// Tracks if the [ToggleButton] input is `checked`. Determines whether to render with the `active` CSS class.
  ///
  /// Initial: [ToggleButtonProps.checked] `??` [ToggleButtonProps.defaultChecked] `?? false`
  bool get isChecked => state[_$key__isChecked];  set isChecked(bool value) => state[_$key__isChecked] = value;
}

@Component(subtypeOf: ButtonComponent)
class ToggleButtonComponent extends ButtonComponent<ToggleButtonProps, ToggleButtonState> with _$ToggleButtonComponentImplMixin {

  @override
  Map getDefaultProps() => (newProps()
    ..addProps(super.getDefaultProps())
    ..toggleType = ToggleBehaviorType.CHECKBOX
  );

  @override
  Map getInitialState() => (newState()
    ..id = 'toggle_button_' + generateGuid()
    ..isFocused = props.autoFocus
    ..isChecked = props.checked ?? props.defaultChecked ?? false
  );

  @override
  get consumedProps => const [
    ToggleButtonProps.$consumedProps /* GENERATED from $Props usage */,
    ButtonProps.$consumedProps /* GENERATED from $Props usage */,
    AbstractInputPropsMixin.$consumedProps /* GENERATED from $Props usage */,
  ];

  // Used to check if the `input` element is controlled or not.
  bool get _isControlled => props.checked != null;

  @override
  bool get _isActive => state.isChecked;

  @override
  String get _type => null;

  @override
  BuilderOnlyUiFactory<DomProps> get _buttonDomNodeFactory => Dom.label;

  /// The id to use for a [ToggleButton].
  ///
  /// Attempts to use [AbstractInputPropsMixin.id] _(specified by the consumer)_, falling back to
  /// [AbstractInputStateMixin.id] _(auto-generated)_.
  String get id => props.id ?? state.id;

  @override
  render() {
    return renderButton(
      [
        renderInput(),
        props.children
      ]
    );
  }

  @override
  void componentWillMount() {
    super.componentWillMount();

    _validateProps(props);
  }

  @override
  void componentWillReceiveProps(Map newProps) {
    super.componentWillReceiveProps(newProps);
    var tNewProps = typedPropsFactory(newProps);

    _validateProps(tNewProps);

    if (tNewProps.checked != null && props.checked != tNewProps.checked) {
      setState(newState()..isChecked = tNewProps.checked);
    }
  }

  ReactElement renderInput() {
    window.console.log(props);
    window.console.log('toggle_button name: ${props.name}');
    var builder = Dom.input()
      ..type = props.toggleType.typeName
      ..id = id
      ..key = 'input'
      ..name = props.name
      ..tabIndex = props.tabIndex
      ..disabled = props.isDisabled
      ..autoFocus = props.autoFocus
      ..onChange = props.onChange
      ..onClick = props.onClick
      ..ref = (ref) { inputRef = ref; };

    // Starting from React 15.0, the checked/defaultChecked props should not be set with a cascading setter because it
    // will recognize the null as a "clear input" rather than a request to make the input controlled or uncontrolled.
    if (props.defaultChecked != null) builder.defaultChecked = state.isChecked;
    if (props.checked != null) builder.checked = state.isChecked;
    // React 15.0 introduced a bug that warns when setting value to null on an input even if that input is of type radio
    // or checkbox. This comes from treating setting value as a controlled input even when  it should not.
    //
    // See: https://github.com/facebook/react/issues/6779
    if (props.value != null) builder.value = props.value;

    return builder();
  }

  /// Checks the `<input>` element to ensure that `state.isChecked` matches its checked attribute.
  ///
  /// Does not refresh the state if the component is controlled.
  void _refreshState() {
    window.console.log('state: ${state.isChecked}');
    window.console.log('ref: ${inputRef.checked}');
    if (!_isControlled) setState(newState()..isChecked = inputRef.checked);
  }

  void _validateProps(ToggleButtonProps props) {
    assert((props.type == ToggleBehaviorType.RADIO && props.name != null) || props.type == ToggleBehaviorType.CHECKBOX);
  }

  // --------------------------------------------------------------------------
  // Abstract Implementations
  // --------------------------------------------------------------------------

  @override
  InputElement inputRef;
}



// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
//   GENERATED IMPLEMENTATIONS
//

// React component factory implementation.
//
// Registers component implementation and links type meta to builder factory.
final $ToggleButtonComponentFactory = registerComponent(() => new ToggleButtonComponent(),
    builderFactory: ToggleButton,
    componentClass: ToggleButtonComponent,
    isWrapper: false,
    parentType: $ButtonComponentFactory, /* from `subtypeOf: ButtonComponent` */
    displayName: 'ToggleButton'
);

// Concrete props implementation.
//
// Implements constructor and backing map, and links up to generated component factory.
class _$ToggleButtonPropsImpl extends ToggleButtonProps {
  /// The backing props map proxied by this class.
  @override
  final Map props;

  _$ToggleButtonPropsImpl(Map backingMap) : this.props = backingMap ?? ({});

  /// Let [UiProps] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The [ReactComponentFactory] associated with the component built by this class.
  @override
  Function get componentFactory => $ToggleButtonComponentFactory;

  /// The default namespace for the prop getters/setters generated for this class.
  @override
  String get propKeyNamespace => 'ToggleButtonProps.';
}

// Concrete state implementation.
//
// Implements constructor and backing map.
class _$ToggleButtonStateImpl extends ToggleButtonState {
  /// The backing state map proxied by this class.
  @override
  final Map state;

  _$ToggleButtonStateImpl(Map backingMap) : this.state = backingMap ?? ({});

  /// Let [UiState] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;
}

// Concrete component implementation mixin.
//
// Implements typed props/state factories, defaults `consumedPropKeys` to the keys
// generated for the associated props class.
class _$ToggleButtonComponentImplMixin {
  /// Let [UiComponent] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The default consumed props, taken from ToggleButtonProps.
  /// Used in [UiProps.consumedProps] if [consumedProps] is not overridden.
  @override
  final List<ConsumedProps> $defaultConsumedProps = const [ToggleButtonProps.$consumedProps];
  @override
  ToggleButtonProps typedPropsFactory(Map backingMap) => new _$ToggleButtonPropsImpl(backingMap);
  @override
  ToggleButtonState typedStateFactory(Map backingMap) => new _$ToggleButtonStateImpl(backingMap);
}

//
//   END GENERATED IMPLEMENTATIONS
//
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
