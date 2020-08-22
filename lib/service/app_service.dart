import 'package:agenda/repository/worker_repository.dart';
import 'package:agenda/service/worker_service.dart';
import 'package:agenda/model/model_provider.dart';
import 'package:sqflite/sqflite.dart';

WorkerRepository _workerRepository=WorkerRepository(ModelProvider.getInstance());
WorkerService _workerService=WorkerService(_workerRepository);

class AppService{

  static WorkerService get workerService => _workerService;
  static Future<Database> open(){
    return ModelProvider.getInstance().open();
  }

  static Future<void>close(){
    return ModelProvider.getInstance().close();
  }
}
