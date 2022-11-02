class Vikingo{
	var property casta = jarl
	var property oro = 0
	
	method puedeIrAExpedicion() = self.esProductivo() && casta.permiteExpedicion(self)
	
	method esProductivo()
	
	method ascenderDeCasta() { 
		casta.ascender(self)
	}
	
	method validarCondicionDeSubida(){
		if(!self.puedeIrAExpedicion()){
			throw new DomainException(message= "El vikingo no puede subir a la expedicion")
		}
	}
	
	method cobrarVida() {}
	
	method ganarOro(cantidad){
		oro += cantidad
	}
}

class Granjero inherits Vikingo{
	var cantHijos
	var cantHectareas
	
	override method esProductivo() = cantHectareas >= cantHijos * 2
	
	method tieneArmas() = false
	
	method brindarAscenso(){
		cantHijos += 2
		cantHectareas += 2
	}
}

class Soldado inherits Vikingo{
	var vidasCobradas
	var property cantArmas 
	
	override method esProductivo() = vidasCobradas >= 20 && self.tieneArmas()
	
	method tieneArmas() = cantArmas >= 1
	
	method brindarAscenso(){
		cantArmas += 10
	}
	
	override method cobrarVida(){
		vidasCobradas += 1
	}
}

//CASTAS

object jarl{
	
	method permiteExpedicion(vikingo) = vikingo.tieneArmas()
	
	method ascender(vikingo) {
		vikingo.casta(karl) 
		vikingo.brindarAscenso()
	} 
}

object karl{
	
	method permiteExpedicion(vikingo) = true
	
	method ascender(vikingo) {
		vikingo.casta(thrall) 
		vikingo.brindarAscenso()
	} 
}

object thrall{
	
	method permiteExpedicion(vikingo) = true
	
	method ascender(vikingo) {
		
	} 
}

class Expedicion{
	const lugaresAInvadir = []
	var integrantes = []
	
	method valeLaPena() = lugaresAInvadir.all{lugar => lugar.valeLaPena(self.cantidadDeIntegrantes())}
	
	method cantidadDeIntegrantes() = integrantes.size()
	
	method subirAExpedicion(vikingo){
		vikingo.validarCondicionDeSubida()
		integrantes.add(vikingo)
	}
	
	method realizarse(){
		lugaresAInvadir.forEach{lugar => lugar.serInvadidoPor(self)}
	}
	
	method repartirBotin(botin) {
		integrantes.forEach{
			integrante => integrante.ganarOro(botin / self.cantidadDeIntegrantes())
		}
	}
	
	method aumentarVidasCobradas(vidas){
		integrantes.take(vidas).forEach{integrante => integrante.cobrarVida()}
	}
	
	
}

class LugaresAInvadir{
	
	method serInvadidoPor(expedicion){
		expedicion.repartirBotin(self.botin(expedicion.cantidadDeIntegrantes()))
		self.invadirse(expedicion)
	}

	method invadirse(expedicion)
	
	method botin(cantIntegrantes)
}

class Aldea inherits LugaresAInvadir{
	var cantCrucifijos
	
	method valeLaPena(cantVikingos)= self.botin(cantVikingos) >= 15
	
	override method botin(cantVikingos) = cantCrucifijos
	
	override method invadirse(expedicion){
		cantCrucifijos = 0
	}
}

class AldeaAmurallada inherits Aldea{
	var cantMinimaVikingos
	
	override method valeLaPena(cantVikingos) = super(cantVikingos) && cantMinimaVikingos <= cantVikingos
}
	

class Capital inherits LugaresAInvadir{
	var cantDefensores
	const factorDeRiqueza
	
	method valeLaPena(cantVikingos)= self.botin(cantVikingos) >= cantVikingos * 3
	
	override method botin(cantVikingos) = self.defensoresDerrotados(cantVikingos) * factorDeRiqueza //cada vikingo se cobra una vida
	
	override method invadirse(expedicion){
		cantDefensores -= self.defensoresDerrotados(expedicion.cantidadDeIntegrantes())
		expedicion.aumentarVidasCobradas(cantDefensores)
	}
	 
	 method defensoresDerrotados(cantVikingos) = cantDefensores.min(cantVikingos)
}

/*
 * Si, los catillos podrian agregarse sin necesidad de modificar codigo ya hecho racias al uso de la herencia y polimorfismo de esta solucion.
 * Agregando una clase Castillo que herede de la clase lugarAInvadir, solo necesitamos definir los metodos botin e invadirse para que estos puedan ser utilizados 
 * indistintamente entre las aldeas, capitales y castillos
 */



