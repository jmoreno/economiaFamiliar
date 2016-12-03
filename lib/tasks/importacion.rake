namespace :importacion do
	
	require 'rubyXL' # Assuming rubygems is already required
	
  desc "Importación de datos desde la antigua hoja de cálculo"
  task migracion: :environment do
  	
  	Activity.delete_all
  	
  	workbook = RubyXL::Parser.parse("#{Rails.root}/lib/assets/private/GastosMorenoRey_20161113.xlsx")
  	worksheet = workbook['MOVIMIENTOS']
  	worksheet.each { |row|
  	
  		account = Account.find_or_create_by(name: '0049 5144 05 2616112337')
  		
  		activity = Activity.new
  		activity.account = account
  		activity.operationDate = row[0].value
  		activity.valueDate = row[1].value
  		activity.name = row[2].value
  		
  		category = nil
  		origin = nil
  		
  		puts activity.description
  		if ( activity.name =~ /ANUL COMPRA EN(.*), TARJ. :(.*)/ )
  			category = Category.find_or_create_by(name: 'REGULARIZACION TARJETA')
  			items = /ANUL COMPRA EN(.*), TARJ. :(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.card = items[2].strip
  		elsif ( activity.name =~ /ANUL. TRANS CONTACTLESS EN(.*), TARJ. :(.*)/ )
  			category = Category.find_or_create_by(name: 'REGULARIZACION TARJETA')
  			items = /ANUL. TRANS CONTACTLESS EN(.*), TARJ. :(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.card = items[2].strip
  		elsif ( activity.name =~ /COMPRA EN(.*), CON LA TARJETA :(.*)EL(.*)/ )
  			category = Category.find_or_create_by(name: 'PAGO CON TARJETA')
  			items = /COMPRA EN(.*), CON LA TARJETA :(.*)EL(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.card = items[2].strip
  		elsif ( activity.name =~ /COMPRA EN(.*), TARJ. :(.*)/ )
  			category = Category.find_or_create_by(name: 'PAGO CON TARJETA')
  			items = /COMPRA EN(.*), TARJ. :(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.card = items[2].strip
  		elsif ( activity.name =~ /DEVOLUCION COMPRA EN(.*), TARJ. :(.*)/ )
  			category = Category.find_or_create_by(name: 'REGULARIZACION TARJETA')
  			items = /DEVOLUCION COMPRA EN(.*), TARJ. :(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.card = items[2].strip
  		elsif ( activity.name =~ /DISPOSICION EFECTIVO EN OFICINA(.*)/ )
  			category = Category.find_or_create_by(name: 'DISPOSICION DE EFECTIVO')
  			items = /DISPOSICION EFECTIVO EN OFICINA(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  		elsif ( activity.name =~ /DISPOSICION EN CAJERO CON LA TARJETA(.*), COMISION(.*), EL(.*)/ )
  			category = Category.find_or_create_by(name: 'DISPOSICION DE EFECTIVO')
  			items = /DISPOSICION EN CAJERO CON LA TARJETA(.*), COMISION(.*), EL(.*)/.match(activity.name)
  			activity.card = items[1].strip
#  			activity.commission = items[2]
  		elsif ( activity.name =~ /EJECUCION EMBARGO/ )
  			category = Category.find_or_create_by(name: 'EJECUCION EMBARGO')
  		elsif ( activity.name =~ /ENTREGA A CUENTA/ )
  			category = Category.find_or_create_by(name: 'ENTREGA A CUENTA')
  		elsif ( activity.name =~ /ENTREGA DE DOCUMENTOS PARA SU COMPENSACION/ )
  			category = Category.find_or_create_by(name: 'ENTREGA DE DOCUMENTOS PARA SU COMPENSACION')
  		elsif ( activity.name =~ /INGRESO EN EFECTIVO DE(.*)EN SUC.(.*)/ )
  			category = Category.find_or_create_by(name: 'INGRESO DE EFECTIVO')
  			items = /INGRESO EN EFECTIVO DE(.*)EN SUC.(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  		elsif ( activity.name =~ /LIQUIDACION DE LA TARJETA DE CREDITO(.*)/ )
  			category = Category.find_or_create_by(name: 'LIQUIDACION TARJETA DE CRÉDITO')
  			items = /LIQUIDACION DE LA TARJETA DE CREDITO(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  		elsif ( activity.name =~ /LIQUIDACION DEL CONTRATO(.*)/ )
  			category = Category.find_or_create_by(name: 'LIQUIDACION DE CONTRATO')
  			items = /LIQUIDACION DEL CONTRATO(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  		elsif ( activity.name =~ /LIQUIDACION PERIODICA PRESTAMO(.*)/ )
  			category = Category.find_or_create_by(name: 'LIQUIDACIÓN PERIÓDICA PRÉSTAMO')
  			items = /LIQUIDACION PERIODICA PRESTAMO(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  		elsif ( activity.name =~ /NOMINA DE(.*):(.*)/ )
  			category = Category.find_or_create_by(name: 'NOMINA')
  			items = /NOMINA DE(.*):(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.reference = items[2].strip
  		elsif ( activity.name =~ /PAGO RECIBO(.*), REFERENCIA(.*)/ )
  			category = Category.find_or_create_by(name: 'PAGO DE RECIBO')
  			items = /PAGO RECIBO(.*), REFERENCIA(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.reference = items[2].strip
  		elsif ( activity.name =~ /PAGO RECIBO DE(.*), NUM.(.*), CONCEPTO(.*)/ )
  			category = Category.find_or_create_by(name: 'PAGO DE RECIBO')
  			items = /PAGO RECIBO DE(.*), NUM.(.*), CONCEPTO(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.reference = items[2].strip
  			activity.concept = items[3].strip
  		elsif ( activity.name =~ /RECIBO(.*)N_ RECIBO(.*)REF. MANDATO(.*)/ )
  			category = Category.find_or_create_by(name: 'PAGO DE RECIBO')
  			items = /RECIBO(.*)N_ RECIBO(.*)REF. MANDATO(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.reference = items[2].strip
  			activity.command = items[3].strip
  		elsif ( activity.name =~ /REGULARIZACION COMPRA EN(.*), CON LA TARJETA :(.*)EL(.*)/ )
  			category = Category.find_or_create_by(name: 'PAGO DE RECIBO')
  			items = /REGULARIZACION COMPRA EN(.*), CON LA TARJETA :(.*)EL(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.card = items[2].strip
  		elsif ( activity.name =~ /REINTEGRO, ATM:(.*), TARJ. :(.*)/ )
  			category = Category.find_or_create_by(name: 'REGULARIZACION TARJETA')
  			items = /REINTEGRO, ATM:(.*), TARJ. :(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.card = items[2].strip
  		elsif ( activity.name =~ /TRANSFERENCIA A FAVOR DE(.*)/ )
  			category = Category.find_or_create_by(name: 'TRANSFERENCIA PARA')
  			items = /TRANSFERENCIA A FAVOR DE(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  		elsif ( activity.name =~ /TRANSFERENCIA A FAVOR DE(.*)CONCEPTO(.*)/ )
  			category = Category.find_or_create_by(name: 'TRANSFERENCIA PARA')
  			items = /TRANSFERENCIA A FAVOR DE(.*)CONCEPTO(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.concept = items[2].strip
  		elsif ( activity.name =~ /TRANSFERENCIA DE(.*), CONCEPTO(.*)/ )
  			category = Category.find_or_create_by(name: 'TRANSFERENCIA DE')
  			items = /TRANSFERENCIA DE(.*), CONCEPTO(.*)/.match(activity.name)
  			origin = Origin.find_or_create_by(name: items[1].strip)
  			activity.concept = items[2].strip
  		end		
	  	activity.category = category
	  	activity.origin = origin
  		activity.amount = row[3].value
  		activity.balance = row[4].value
  		activity.save
		}
  	
  end

  desc "TODO"
  task movimientosSantander: :environment do
  	workbook = RubyXL::Parser.parse("#{Rails.root}/lib/assets/private/GastosMorenoRey_20161113.xlsx")
  	
  	
  end

  desc "TODO"
  task movimientosBankinter: :environment do
  end

end
