import 'package:agenda/domain/worker.dart';
import 'package:agenda/repository/worker_repository.dart';

class WorkerService {
  final WorkerRepository repository;

  const WorkerService(this.repository);

  Future<int> createWorker(Worker domain) {
    return repository.create(domain);
  }

  Future<List<Worker>> findAllWorkers(String searchCriteria) {
    return repository.findAll(searchCriteria);
  }

  Future<Worker> findWorkerBy({int id}) {
    return repository.findOne(id);
  }

  Future<int> deleteWorkerBy({ int id}) {
    return repository.delete(id);
  }
  Future<int> updateWorkerBy({int id, Worker domain}){
    return repository.update(id, domain);
  }

}