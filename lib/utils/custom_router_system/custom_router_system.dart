import 'dart:io';

import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/utils/custom_router_system/helpers/server_handler_model.dart';
import 'package:windows_app/utils/custom_router_system/helpers/server_middleware_model.dart';
import 'package:windows_app/utils/errors_collection/custom_exception.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/custom_router_system/helpers/server_requests_utils.dart';

class CustomRouterSystem {
  List<ServerHandlerModel> handlers = [];
  List<ServerMiddlewareModel> middlewares = [];

  void addHandler(
    String path,
    HttpMethod method,
    Function(
      HttpRequest request,
      HttpResponse response,
    )
        callback,
  ) {
    try {
      if (handlers
          .any((element) => element.path == path && element.method == method)) {
        throw Exception(
            'This endpoint(router) is already defined : $path $method');
      }
      ServerHandlerModel routerModel = ServerHandlerModel(
        path: path,
        method: method,
        callback: callback,
      );
      handlers.add(routerModel);
    } catch (e, s) {
      throw CustomException(
        e: e,
        s: s,
        rethrowError: true,
      );
    }
  }

  void addMiddleware(
    List<String> paths,
    HttpMethod method,
    Future<MiddlewareReturn> Function(
      HttpRequest request,
      HttpResponse response,
    )
        callback,
  ) {
    ServerMiddlewareModel serverMiddlewareModel = ServerMiddlewareModel(
      paths: paths,
      httpMethod: method,
      callback: callback,
    );
    middlewares.add(serverMiddlewareModel);
  }

  void pipeline(HttpRequest request) async {
    HttpRequest pipelineRequest = request;
    HttpResponse pipelineResponse = request.response;
    // the middleware will return the request that will passed to the handler
    //first get the middleware that matches the path
    // if the middleware paths is empty this mean that it will run on each request
    String path = request.uri.path;
    HttpMethod method = stringToHttpMethod(request.method);

    List<ServerMiddlewareModel> appliedMiddlewares = middlewares
        .where((element) =>
            (element.paths.contains(path) || element.paths.isEmpty) &&
            element.httpMethod == method)
        .toList();
    for (var middleware in appliedMiddlewares) {
      var middlewareReturn =
          middleware.callback(pipelineRequest, pipelineResponse);
      pipelineRequest = (await middlewareReturn).request;
      pipelineResponse = (await middlewareReturn).response;
      bool closed = (await middlewareReturn).closed;
      String? closeReason = (await middlewareReturn).closeReason;
      //! when a middleware closes a response it might pass closed reason to the to the return and if so , i won't continue the pipeline and return from here
      if (closed) {
        logger.w('Response Closed with reason: $closeReason');
        return;
      }
    }
    // after finishing the previous loop the copiedRequest and copiedResponse will be modified depending the middleware
    // the handler is just one, so i will just need to call a method to do that work
    runHandler(
      pipelineRequest,
      pipelineResponse,
      path,
      method,
      (request, response) => null,
    );
  }

  Future<void> runHandler(
    HttpRequest pipeLineRequest,
    HttpResponse pipLineResponse,
    String path,
    HttpMethod method,
    Function(HttpRequest request, HttpResponse response)? onNotFound,
  ) async {
    try {
      ServerHandlerModel serverHandlerModel = handlers.firstWhere(
          (element) => element.path == path && element.method == method);
      await serverHandlerModel.callback(pipeLineRequest, pipLineResponse);
      try {
        await pipLineResponse.close();
      } catch (e) {
        printOnDebug(e);
        printOnDebug('Can\'nt close the response stream');
      }
    } catch (e) {
      // if here that means that the user entered a path that doesn't exist
      if (onNotFound != null) {
        onNotFound(pipeLineRequest, pipLineResponse);
      }
    }
  }

  // void handlerListen(HttpRequest request) async {
  //   try {
  //     HttpMethod method = stringToHttpMethod(request.method);
  //     for (var router in handlers) {
  //       Uri uri = Uri.parse(router.path);
  //       if (request.uri.path.contains(uri.path) && router.method == method) {
  //         await router.callback(request, request.response);
  //         //? i added this close statement here to skip typing it in each request
  //         try {
  //           request.response.close();
  //         } catch (e) {
  //           printOnDebug(e);
  //           printOnDebug('Can\'nt close the stream');
  //         }
  //         //? to break from the loop if the wanted endpoint satisfied
  //         break;
  //       }
  //     }
  //   } catch (e, s) {
  //     throw CustomException(
  //       e: e,
  //       s: s,
  //       rethrowError: true,
  //     );
  //   }
  // }
}
