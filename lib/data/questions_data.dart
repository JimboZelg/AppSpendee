class Question {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });
}

class LevelData {
  final String title;
  final List<String> exercises;
  final List<Question> questions;
  final int pointsPerCorrect;
  final String advice;

  LevelData({
    required this.title,
    required this.exercises,
    required this.questions,
    required this.pointsPerCorrect,
    required this.advice,
  });
}

final List<LevelData> levelsData = [

  LevelData(
    title: 'Nivel 1: Conceptos básicos de ahorro',
    exercises: [
      'Separar una lista de productos en "Gastos" y "Ahorros".',
      'Seleccionar qué hábitos son de ahorro.',
      'Identificar cuándo ahorrar: ¿antes o después de gastar?',
    ],
    questions: [
      Question(
        question: '¿Qué es ahorrar?',
        options: [
          'Ahorrar es gastar todo el dinero',
          'Ahorrar es gastar más de lo que ganas',
          'Ahorrar es guardar una parte del dinero',
          'Ahorrar es pedir prestado',
        ],
        correctOptionIndex: 2,
      ),
      Question(
        question: '¿Por qué es importante ahorrar?',
        options: [
          'Para tener seguridad financiera',
          'Para gastar en más cosas',
          'Para endeudarse',
          'Para comprar innecesariamente',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Cuándo es mejor ahorrar?',
        options: [
          'Después de gastar',
          'Solo a fin de año',
          'Cada vez que sobre dinero',
          'Antes de gastar',
        ],
        correctOptionIndex: 3,
      ),
    ],
    pointsPerCorrect: 5,
    advice: 'Aprender a ahorrar es el primer paso para tener estabilidad financiera.',
  ),

  LevelData(
    title: 'Nivel 2: Presupuesto personal',
    exercises: [
      'Armar un presupuesto mensual básico.',
      'Clasificar gastos fijos y variables.',
      'Simular qué pasa si no presupuestas.',
    ],
    questions: [
      Question(
        question: '¿Qué es un presupuesto?',
        options: [
          'Es un plan de gastos',
          'Es una deuda',
          'Es un préstamo',
          'Es un capricho',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Cuál es un gasto fijo?',
        options: [
          'Pago de renta',
          'Compras impulsivas',
          'Cine',
          'Helados',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Qué sucede si no presupuestas?',
        options: [
          'Gastas más de lo que ganas',
          'Ahorra más',
          'Evitas deudas mágicamente',
          'Se controla solo',
        ],
        correctOptionIndex: 0,
      ),
    ],
    pointsPerCorrect: 6,
    advice: 'El presupuesto es tu mapa financiero: sin él, es muy fácil perderse.',
  ),

  LevelData(
    title: 'Nivel 3: Control de gastos',
    exercises: [
      'Detectar "gastos hormiga" en un mes.',
      'Comparar gasto hormiga vs ahorro.',
      'Eliminar gastos innecesarios en una simulación.',
    ],
    questions: [
      Question(
        question: '¿Qué es un gasto hormiga?',
        options: [
          'Pequeños gastos diarios que se acumulan',
          'Grandes inversiones',
          'Créditos grandes',
          'Ahorros automáticos',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Cómo afecta el gasto hormiga?',
        options: [
          'Reduce tu ahorro',
          'Mejora tus ingresos',
          'No afecta',
          'Aumenta la inversión',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Cómo evitar el gasto hormiga?',
        options: [
          'Ignorarlo',
          'Detectarlo y controlarlo',
          'Gastar más',
          'No registrar tus gastos',
        ],
        correctOptionIndex: 1,
      ),
    ],
    pointsPerCorrect: 7,
    advice: 'Controla tus gastos pequeños. Son los que silenciosamente destruyen tus ahorros.',
  ),

  LevelData(
    title: 'Nivel 4: Ahorro programado',
    exercises: [
      'Configurar una simulación de ahorro automático.',
      'Decidir porcentajes de ahorro.',
      'Comparar ahorro manual vs automático.',
    ],
    questions: [
      Question(
        question: '¿Qué es el ahorro automático?',
        options: [
          'Guardar dinero sin pensarlo',
          'Prestar dinero',
          'Gastar rápido',
          'No ahorrar',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Cuál es la ventaja del ahorro automático?',
        options: [
          'Facilita ahorrar',
          'Dificulta ahorrar',
          'Provoca deudas',
          'No sirve',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Cuándo debes automatizar tu ahorro?',
        options: [
          'Después de gastar',
          'Siempre que recibes dinero',
          'Cuando sobre dinero',
          'Solo a fin de mes',
        ],
        correctOptionIndex: 1,
      ),
    ],
    pointsPerCorrect: 8,
    advice: 'Automatiza el ahorro para construir un hábito sin esfuerzo.',
  ),

  LevelData(
    title: 'Nivel 5: Deuda buena vs deuda mala',
    exercises: [
      'Clasificar tipos de deudas.',
      'Detectar deudas innecesarias.',
      'Priorizar pagos de deudas.',
    ],
    questions: [
      Question(
        question: '¿Qué es una deuda buena?',
        options: [
          'Préstamo para educación',
          'Compras impulsivas',
          'Viajes innecesarios',
          'Lujos',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Qué es una deuda mala?',
        options: [
          'Compra innecesaria con crédito',
          'Crédito educativo',
          'Crédito hipotecario',
          'Ahorro automático',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Qué hacer si tienes deuda mala?',
        options: [
          'Ignorarla',
          'Pagarla lo antes posible',
          'Aumentarla',
          'Esperar intereses',
        ],
        correctOptionIndex: 1,
      ),
    ],
    pointsPerCorrect: 9,
    advice: 'No todas las deudas son malas: aprende a identificar y evitar las peligrosas.',
  ),
  
    LevelData(
    title: 'Nivel 6: Inversiones iniciales',
    exercises: [
      'Simular compra de acciones.',
      'Identificar riesgos de inversión.',
      'Diversificar una pequeña inversión.',
    ],
    questions: [
      Question(
        question: '¿Qué es una acción?',
        options: [
          'Parte de una empresa',
          'Un gasto hormiga',
          'Un préstamo',
          'Una deuda',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Por qué invertir?',
        options: [
          'Para crecer tu dinero',
          'Para gastar más',
          'Para endeudarte',
          'Para no ahorrar',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Qué riesgo tiene invertir?',
        options: [
          'Pérdida de dinero',
          'Aumento garantizado',
          'Seguridad total',
          'No hay riesgo',
        ],
        correctOptionIndex: 0,
      ),
    ],
    pointsPerCorrect: 10,
    advice: 'Invertir es arriesgar, pero no hacerlo también es un riesgo.',
  ),

  LevelData(
    title: 'Nivel 7: Fondos de emergencia',
    exercises: [
      'Crear un fondo en simulador.',
      'Estimar gastos de emergencia.',
      'Simular retiro de fondo de emergencia.',
    ],
    questions: [
      Question(
        question: '¿Qué es un fondo de emergencia?',
        options: [
          'Dinero reservado para imprevistos',
          'Dinero para lujos',
          'Dinero de vacaciones',
          'Ahorro para viajes',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Cuánto debe cubrir un fondo de emergencia?',
        options: [
          '3 a 6 meses de gastos',
          '1 semana',
          '1 mes',
          'Solo un día',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Cuándo usar el fondo de emergencia?',
        options: [
          'Solo en emergencias reales',
          'Para comprar ropa',
          'Para regalos',
          'Para cine',
        ],
        correctOptionIndex: 0,
      ),
    ],
    pointsPerCorrect: 11,
    advice: 'Un fondo de emergencia te da tranquilidad cuando más la necesitas.',
  ),

  LevelData(
    title: 'Nivel 8: Diversificación financiera',
    exercises: [
      'Armar portafolio diversificado.',
      'Detectar inversión riesgosa.',
      'Simular pérdida por no diversificar.',
    ],
    questions: [
      Question(
        question: '¿Qué es diversificar?',
        options: [
          'Invertir en varios lugares',
          'Apostar en una sola inversión',
          'Ahorrar todo',
          'Endeudarse',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Por qué diversificar?',
        options: [
          'Para reducir riesgos',
          'Para aumentar gastos',
          'Para evitar ahorro',
          'Para perder dinero',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Qué pasa si no diversificas?',
        options: [
          'Riesgo de perder todo',
          'Más seguridad',
          'Ganancia segura',
          'Ahorro automático',
        ],
        correctOptionIndex: 0,
      ),
    ],
    pointsPerCorrect: 12,
    advice: 'Diversificar tus inversiones reduce el riesgo y protege tu dinero.',
  ),

  LevelData(
    title: 'Nivel 9: Impuestos y finanzas personales',
    exercises: [
      'Simular pago de IVA e ISR.',
      'Clasificar tipos de impuestos.',
      'Estimar cuánto pagas en impuestos.',
    ],
    questions: [
      Question(
        question: '¿Qué es IVA?',
        options: [
          'Impuesto al consumo',
          'Ahorro automático',
          'Crédito fiscal',
          'Gasto hormiga',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Qué es ISR?',
        options: [
          'Impuesto sobre la renta',
          'Gasto personal',
          'Fondo de emergencia',
          'Deuda buena',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Por qué es importante saber de impuestos?',
        options: [
          'Para planear mejor tus finanzas',
          'Para ignorarlo',
          'Para endeudarte',
          'Para gastar más',
        ],
        correctOptionIndex: 0,
      ),
    ],
    pointsPerCorrect: 13,
    advice: 'Conocer tus impuestos te permite planificar mejor tu economía.',
  ),

  LevelData(
    title: 'Nivel 10: Libertad financiera',
    exercises: [
      'Diseñar un plan de independencia financiera.',
      'Estimar ingresos pasivos necesarios.',
      'Simular vida con libertad financiera.',
    ],
    questions: [
      Question(
        question: '¿Qué es libertad financiera?',
        options: [
          'No depender de un salario',
          'Gastar mucho',
          'Pedir préstamos',
          'Ahorrar poco',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Cómo lograr libertad financiera?',
        options: [
          'Invirtiendo inteligentemente',
          'Gastando más',
          'Aumentando deudas',
          'Ignorando gastos',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: '¿Qué necesitas para ser libre financieramente?',
        options: [
          'Ingresos pasivos',
          'Deuda alta',
          'Gasto hormiga',
          'Ahorro inexistente',
        ],
        correctOptionIndex: 0,
      ),
    ],
    pointsPerCorrect: 15,
    advice: 'La libertad financiera llega cuando tus ingresos pasivos cubren tu estilo de vida.',
  ),

];