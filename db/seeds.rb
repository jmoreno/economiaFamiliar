# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#Character.create(name: 'Luke', movie: movies.first)

User.delete_all
CategoryRegex.delete_all

user = User.new
user.email = 'admin@economiafamiliar.com'
user.password = 'piopioqueyonohesido'
user.password_confirmation = 'piopioqueyonohesido'
user.admin = true
user.save!

user = User.new
user.email = 'user@economiafamiliar.com'
user.password = 'vayalioelmontepio'
user.password_confirmation = 'vayalioelmontepio'
user.admin = false
user.save!

CategoryRegex.create([
{regex: 'ANUL COMPRA EN(.*), TARJ. :(.*)', category_name: 'REGULARIZACION TARJETA', origin: 1, card: 2, reference: 0, concept: 0, command: 0}, 
{regex: 'ANUL. TRANS CONTACTLESS EN(.*), TARJ. :(.*) ', category_name: 'REGULARIZACION TARJETA', origin: 1, card: 2, reference: 0, concept: 0, command: 0}, 
{regex: 'COMPRA EN(.*), CON LA TARJETA :(.*)EL(.*) ', category_name: 'PAGO CON TARJETA', origin: 1, card: 2, reference: 0, concept: 0, command: 0}, 
{regex: 'COMPRA EN(.*), TARJ. :(.*) ', category_name: 'PAGO CON TARJETA', origin: 1, card: 2, reference: 0, concept: 0, command: 0}, 
{regex: 'COMPRA EN(.*), TARJETA(.*), COMISION(.*) ', category_name: 'PAGO CON TARJETA', origin: 1, card: 2, reference: 0, concept: 0, command: 0}, 
{regex: 'DEVOLUCION COMPRA EN(.*), TARJ. :(.*) ', category_name: 'REGULARIZACION TARJETA', origin: 1, card: 2, reference: 0, concept: 0, command: 0}, 
{regex: 'DISPOSICION EFECTIVO EN OFICINA(.*) ', category_name: 'OPERACIONES DE OFICINA', origin: 0, card: 1, reference: 0, concept: 0, command: 0}, 
{regex: 'DISPOSICION EN CAJERO CON LA TARJETA(.*), COMISION(.*), EL(.*) ', category_name: 'DISPOSICION DE EFECTIVO', origin: 0, card: 1, reference: 0, concept: 0, command: 0}, 
{regex: 'EJECUCION EMBARGO ', category_name: 'EJECUCION EMBARGO', origin: 0, card: 0, reference: 0, concept: 0, command: 0}, 
{regex: 'ENTREGA A CUENTA ', category_name: 'ENTREGA A CUENTA', origin: 0, card: 0, reference: 0, concept: 0, command: 0}, 
{regex: 'ENTREGA DE DOCUMENTOS PARA SU COMPENSACION ', category_name: 'ENTREGA DE DOCUMENTOS PARA SU COMPENSACION', origin: 0, card: 0, reference: 0, concept: 0, command: 0}, 
{regex: 'INGRESO EN EFECTIVO DE(.*)EN SUC.(.*) ', category_name: 'OPERACIONES DE OFICINA', origin: 2, card: 0, reference: 0, concept: 0, command: 0}, 
{regex: 'LIQUIDACION DE LA TARJETA DE CREDITO(.*) ', category_name: 'LIQUIDACION TARJETA DE CRÉDITO', origin: 1, card: 0, reference: 0, concept: 0, command: 0}, 
{regex: 'LIQUIDACION DEL CONTRATO(.*) ', category_name: 'LIQUIDACION DE CONTRATO', origin: 1, card: 0, reference: 0, concept: 0, command: 0}, 
{regex: 'LIQUIDACION PERIODICA PRESTAMO(.*) ', category_name: 'LIQUIDACIÓN PERIÓDICA PRÉSTAMO', origin: 1, card: 0, reference: 0, concept: 0, command: 0}, 
{regex: 'NOMINA DE(.*):(.*) ', category_name: 'NOMINA', origin: 1, card: 0, reference: 0, concept: 2, command: 0}, 
{regex: 'PAGO RECIBO(.*), REFERENCIA(.*) ', category_name: 'PAGO DE RECIBO', origin: 1, card: 0, reference: 2, concept: 0, command: 0}, 
{regex: 'PAGO RECIBO DE(.*), NUM.(.*), CONCEPTO(.*) ', category_name: 'PAGO DE RECIBO', origin: 1, card: 0, reference: 2, concept: 3, command: 0}, 
{regex: 'RECIBO(.*)N_ RECIBO(.*)REF. MANDATO(.*) ', category_name: 'PAGO DE RECIBO', origin: 1, card: 0, reference: 2, concept: 0, command: 3}, 
{regex: 'RECIBO(.*)Nº RECIBO(.*)REF. MANDATO(.*) ', category_name: 'PAGO DE RECIBO', origin: 1, card: 0, reference: 2, concept: 0, command: 3}, 
{regex: 'REGULARIZACION COMPRA EN(.*), CON LA TARJETA :(.*)EL(.*) ', category_name: 'REGULARIZACION TARJETA', origin: 1, card: 2, reference: 0, concept: 0, command: 0}, 
{regex: 'REGULARIZACION DISPOSICION CAJERO DEL(.*), TARJETA NUMERO:(.*), COMISION:(.*) ', category_name: 'DISPOSICION DE EFECTIVO', origin: 0, card: 2, reference: 0, concept: 0, command: 0}, 
{regex: 'REINTEGRO, ATM:(.*), TARJ. :(.*) ', category_name: 'DISPOSICION DE EFECTIVO', origin: 1, card: 2, reference: 0, concept: 0, command: 0}, 
{regex: 'TRANSFERENCIA A FAVOR DE(.*) ', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 0, command: 0}, 
{regex: 'TRANSFERENCIA A FAVOR DE(.*)CONCEPTO(.*) ', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 2, command: 0}, 
{regex: 'TRANSFERENCIA DE(.*), CONCEPTO(.*) ', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 2, command: 0}, 
{regex: 'TRANSFERENCIA RECIBIDA DE(.*), CONCEPTO(.*) ', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 2, command: 0}, 
{regex: 'TRANSFERENCIA RECIBIDA DE(.*). CONCEPTO(.*) ', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 2, command: 0},
{regex: '#COMISION DE ADMINISTRACION', category_name: 'GASTOS Y COMISIONES', origin: 0, card: 0, reference: 0, concept: 0, command: 0},{regex: 'CAJA (.*): (.*)', category_name: 'OPERACIONES DE OFICINA', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'CAJERO BANKINTER OF.(.*)', category_name: 'DISPOSICION DE EFECTIVO', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'COM APER PT: (.*)', category_name: 'GASTOS Y COMISIONES', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'CUOTA ANUAL VISA ELECT. (.*)', category_name: 'GASTOS Y COMISIONES', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'IMP INIC PT: (.*)', category_name: 'IMPORTE INICIAL PRESTAMO', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'LIQUID. CUOTA PTMO. (.*)', category_name: 'LIQUIDACIÓN PERIÓDICA PRÉSTAMO', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'RECIBO /(.*)', category_name: 'PAGO DE RECIBO', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'RECTIF. LIQ. CTA. (.*)', category_name: 'LIQUIDACION DE CONTRATO', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'TRANS /(.*)', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'TRANSF /(.*)', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'TRANSF INTERN /(.*)', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'TRANSF NOMI /(.*)', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'TRANSF NOMIN /(.*)', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'TRANSF O /(.*)', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 0, command: 0},{regex: 'TRANSF OTRAS ENTID /(.*)', category_name: 'TRANSFERENCIA', origin: 1, card: 0, reference: 0, concept: 0, command: 0}
])
