// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ViewTouchF';

  @override
  String get language => 'Idioma';

  @override
  String get saveSettings => 'Guardar ajustes';

  @override
  String get restaurantSettings => 'Configuración del restaurante';

  @override
  String get tapMenuToBegin => 'Toque un elemento del menú para comenzar';

  @override
  String get phoneOrder => 'PEDIDO TELEFÓNICO';

  @override
  String get checkout => 'Pagar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get done => 'Listo';

  @override
  String get cannotConnectToDaemon => 'No se puede conectar con el demonio POS';

  @override
  String get retry => 'Reintentar';

  @override
  String get shutdownSystem => 'Apagar sistema';

  @override
  String get refresh => 'Actualizar';

  @override
  String get selectPrinter => 'Seleccionar impresora';

  @override
  String get receiptPrinter => 'Impresora de recibos';

  @override
  String get kitchenPrinter => 'Impresora de cocina';

  @override
  String get noCupsPrinters =>
      'No se encontraron impresoras CUPS en este sistema.';

  @override
  String get saveFailed => 'Error al guardar';

  @override
  String get shutdown => 'Apagar';

  @override
  String get pastOrders => 'Pedidos anteriores';

  @override
  String get phoneOrders => 'Pedidos telefónicos';

  @override
  String get admin => 'Administración';

  @override
  String get ticketLabel => 'Ticket:';

  @override
  String get cash => 'EFECTIVO';

  @override
  String get card => 'TARJETA';

  @override
  String get exact => 'Exacto';

  @override
  String get clear => 'Limpiar';

  @override
  String get undoLastPayment => 'Deshacer último pago';

  @override
  String phoneOrderCreatedForName(Object name) {
    return 'Pedido telefónico creado para $name';
  }

  @override
  String get phoneOrderCreated => 'Pedido telefónico creado';

  @override
  String get phoneOrderLoadedForEditing =>
      'Pedido telefónico cargado para editar';

  @override
  String get phoneOrderTitle => 'Pedido telefónico';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get customerLabel => 'cliente';

  @override
  String get todaysOrders => 'Pedidos de hoy';

  @override
  String get reprint => 'Reimprimir';

  @override
  String get phoneOrderLoaded => 'Pedido telefónico cargado';

  @override
  String get addCreditCardFee => 'Agregar tarifa por tarjeta';

  @override
  String get noOrdersFound => 'No se encontraron pedidos';

  @override
  String get addToOrder => 'Agregar al pedido';

  @override
  String get updateItem => 'Actualizar artículo';

  @override
  String get specialInstructions => 'Instrucciones especiales';

  @override
  String get instructionsChecked => 'Instrucciones ✓';

  @override
  String get defaultLabel => 'Predeterminado';

  @override
  String get included => 'Incluido';

  @override
  String get modNo => 'NO';

  @override
  String get modAdd => 'AGREGAR';

  @override
  String get modExtra => 'EXTRA';

  @override
  String get modLight => 'LIGERO';

  @override
  String get modSide => 'A UN LADO';

  @override
  String get modDouble => 'DOBLE';

  @override
  String get total => 'Total';

  @override
  String get ccFee => 'Tarifa CC';

  @override
  String get newTotal => 'Nuevo total';

  @override
  String get remaining => 'Restante';

  @override
  String errorOccurred(Object error) {
    return 'Error: $error';
  }

  @override
  String get changeDueLabel => 'Cambio:';

  @override
  String get voidLabel => 'ANULAR';

  @override
  String get comp => 'COMP';

  @override
  String get refund => 'REEMBOLSO';

  @override
  String get printError => 'Error de impresión';

  @override
  String get kitchenPrintError => 'Error de impresión en cocina';

  @override
  String receiptReprinted(Object jobId) {
    return 'Recibo reimpreso (Trabajo #$jobId)';
  }

  @override
  String get changeLabel => 'Cambio';

  @override
  String paymentLabel(Object type) {
    return '$type pago';
  }

  @override
  String get addItemFailed => 'Error al agregar artículo';

  @override
  String get increaseItemFailed => 'Error al aumentar artículo';

  @override
  String get updateItemFailed => 'Error al actualizar artículo';

  @override
  String get decreaseItemFailed => 'Error al disminuir artículo';

  @override
  String get removeItemFailed => 'Error al eliminar artículo';

  @override
  String get setQuantityFailed => 'Error al establecer cantidad';

  @override
  String get loadPhoneOrderFailed => 'Error al cargar pedido telefónico';

  @override
  String get checkoutFailed => 'Error al pagar';

  @override
  String operationFailed(Object action) {
    return '$action falló';
  }

  @override
  String get noActiveTicket => 'No hay ticket activo';

  @override
  String get enterQuantity => 'Ingrese cantidad';

  @override
  String get removeItemTitle => 'Eliminar artículo';

  @override
  String removeItemConfirm(Object name, Object qty) {
    return '¿Eliminar $name (cant $qty) del pedido?';
  }

  @override
  String get remove => 'Eliminar';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get tax => 'Impuesto';

  @override
  String get enterText => 'Ingresar texto';

  @override
  String get spaceLabel => 'ESPACIO';

  @override
  String get menuItems => 'Elementos del menú';

  @override
  String get addItem => 'Agregar artículo';

  @override
  String get noMenuItems => 'No hay artículos. Agregue uno arriba.';

  @override
  String get deleteMenuItemTitle => 'Eliminar artículo del menú';

  @override
  String deleteMenuItemConfirm(Object name) {
    return '¿Eliminar \"$name\" del menú?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get itemAdded => 'Artículo agregado';

  @override
  String get itemUpdated => 'Artículo actualizado';

  @override
  String get itemDeleted => 'Artículo eliminado';

  @override
  String get editMenuItem => 'Editar artículo del menú';

  @override
  String get newMenuItem => 'Nuevo artículo del menú';

  @override
  String get save => 'Guardar';

  @override
  String get add => 'Agregar';

  @override
  String get itemDetails => 'Detalles del artículo';

  @override
  String get itemIdLabel => 'ID del artículo';

  @override
  String get itemNameLabel => 'Nombre del artículo';

  @override
  String get priceLabel => 'Precio (\$)';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get sendToKitchen => 'Enviar a cocina';

  @override
  String get sendToKitchenSubtitle =>
      'Imprimir este artículo en los tickets de cocina';

  @override
  String get modifierGroups => 'Grupos de modificadores';

  @override
  String get addGroup => 'Agregar grupo';

  @override
  String get noModifierGroups =>
      'No hay grupos de modificadores. Los artículos se agregarán tal cual.';

  @override
  String get groupIdLabel => 'ID del grupo';

  @override
  String get groupNameLabel => 'Nombre del grupo';

  @override
  String get minSelectLabel => 'Selección mínima';

  @override
  String get maxSelectLabel => 'Selección máxima';

  @override
  String get removeGroup => 'Eliminar grupo';

  @override
  String get noModifiersInGroup => 'No hay modificadores en este grupo.';

  @override
  String get addModifier => 'Agregar modificador';

  @override
  String get modifierIdLabel => 'ID del modificador';

  @override
  String get modifierNameLabel => 'Nombre del modificador';

  @override
  String get modifierPriceLabel => 'Precio del modificador';

  @override
  String get priceShort => 'Precio';

  @override
  String get loadMenuFailed => 'Error al cargar el menú';

  @override
  String get reasonOptional => 'Razón (opcional)';

  @override
  String get all => 'Todos';

  @override
  String get open => 'Abiertos';

  @override
  String get restore => 'Restaurar';

  @override
  String get show => 'Mostrar';

  @override
  String get replace => 'Reemplazar';

  @override
  String get closed => 'Cerrados';

  @override
  String get voided => 'Anulados';

  @override
  String get comped => 'Cortesía';

  @override
  String get refunded => 'Reembolsados';

  @override
  String get commentLabel => 'Comentario';

  @override
  String get noteLabel => 'Nota:';

  @override
  String get cancelOrder => 'Cancelar pedido';

  @override
  String get editOrder => 'Editar pedido';

  @override
  String get skipPrinting => 'Omitir impresión';

  @override
  String get selectReportDate => 'Seleccionar fecha del informe';

  @override
  String get daily => 'Diario';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensual';

  @override
  String get yearly => 'Anual';

  @override
  String get custom => 'Personalizado';

  @override
  String get printLabel => 'Imprimir';

  @override
  String get noData => 'Sin datos';

  @override
  String reportForDate(Object date) {
    return 'Informe — $date';
  }

  @override
  String get dailyBreakdown => 'Desglose diario';

  @override
  String get tickets => 'tickets';

  @override
  String get grossRevenue => 'Ingresos brutos';

  @override
  String get netRevenue => 'Ingresos netos';

  @override
  String get totalCollected => 'Total recaudado';
}
