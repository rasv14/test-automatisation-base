@REQ_CTNREM-000 @GetHeroes
Feature: Obtener todos los personajes

  Background:
    * def numeroClon = call read('classpath:Utils/CodigoAleatorio.js')

  Scenario:  T-API-CTNREM-000-CA1-Obtener Todos los Personajes de Marvel
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters'
    When method GET
    Then status 200
    * print response
    And match response[0] contains { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#[]' }

  Scenario: T-API-CTNREM-000-CA2-Obtener el personaje con ID 1
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters/1'
    When method GET
    Then status 200
    And match response contains { id: 1, name: '#string', alterego: '#string', description: '#string' }
    * print response

  Scenario: T-API-CTNREM-000-CA3-Crear un personaje valido
    * def nombreClon = 'SuperHeroe Clon ' + numeroClon
    * def requestBody =
    """
    {
      "name": "",
      "alterego": "Peter Parker",
      "description": "Superhéroe arácnido de Marvel",
      "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
    }
    """
    * set requestBody.name = nombreClon
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters'
    And request requestBody
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * print response
    * def result = { idCreado: response.id }


  Scenario: T-API-CTNREM-000-CA4-Crear personaje con nombre duplicado (error 400)
    * def requestBody = { name: 'Spider-Man', alterego: 'Peter Parker', description: 'Otro intento duplicado', powers: ['Agilidad'] }
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters'
    And request requestBody
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.error == 'Character name already exists'

  Scenario: T-API-CTNREM-000-CA5-Crear personaje con datos inválidos (error 400)
    * def requestBody = { name: '', alterego: '', description: '', powers: [] }
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters'
    And request requestBody
    And header Content-Type = 'application/json'
    When method POST
    Then status 400

  Scenario: T-API-CTNREM-000-CA6-Obtener personaje inexistente (error 404)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters/9999'
    When method GET
    Then status 404

  Scenario: T-API-CTNREM-000-CA7-Actualizar personaje válido
    * def requestBody = { name: 'Spider-Man', alterego: 'Peter Parker', description: 'Superhéroe arácnido de Marvel (actualizado)', powers: ['Agilidad', 'Sentido arácnido', 'Trepar muros'] }
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters/1'
    And request requestBody
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And match response contains { id: 1, name: 'Spider-Man', alterego: 'Peter Parker', description: 'Superhéroe arácnido de Marvel (actualizado)', powers: ['Agilidad', 'Sentido arácnido', 'Trepar muros'] }

  Scenario: T-API-CTNREM-000-CA8-Actualizar personaje inexistente (error 404)
    * def requestBody = { name: 'No existe', alterego: 'Nadie', description: 'No existe', powers: ['Nada'] }
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters/9999'
    And request requestBody
    And header Content-Type = 'application/json'
    When method PUT
    Then status 404

  Scenario: T-API-CTNREM-000-CA9-Eliminar personaje válido
    * def nombreClon = 'SuperHeroe Clon ' + numeroClon
    * def requestBody =
    """
    {
      "name": "",
      "alterego": "Peter Parker",
      "description": "Superhéroe arácnido de Marvel",
      "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
    }
    """
    * set requestBody.name = nombreClon
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters'
    And request requestBody
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def idCreado = response.id
    * print 'ID creado:', idCreado

    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/roasanch/api/characters/' + idCreado
    When method DELETE
    Then status 204

  Scenario: T-API-CTNREM-000-CA10-Eliminar personaje inexistente (error 404)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/9999'
    When method DELETE
    Then status 404